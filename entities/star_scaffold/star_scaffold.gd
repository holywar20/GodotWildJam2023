class_name StarScaffold
extends Node2D


const MESSAGE_INSUFFICIENT_RESOURCES = "Insufficient resources to build!"
const MESSAGE_INSUFFICIENT_SPACE = "No more space left for structures!"
const MESSAGE_INSUFFICIENT_OPERATING_RESOURCES = "One or more structures can't produce due to insufficient resources!"

const construction_sprite = preload("res://Assets/buildings/ConstructionPlaceholder.png")

const BUILD_POS = {
	Vector2(0,0) : Vector2(-109,-839),
	Vector2(0,1) : Vector2(-320,-791),
	Vector2(0,2) : Vector2(-501,-679),
	Vector2(0,3) : Vector2(-665,-531),
	Vector2(0,4) : Vector2(-773,-343),
	Vector2(0,5) : Vector2(-833,-123),
	Vector2(1,0) : Vector2( 90 ,-839),
	Vector2(1,1) : Vector2(302,-790),
	Vector2(1,2) : Vector2(482,-678),
	Vector2(1,3) : Vector2(646,-531),
	Vector2(1,4) : Vector2(755,-343),
	Vector2(1,5) : Vector2(814,-123),
	Vector2(2,0) : Vector2(-109,829),
	Vector2(2,1) : Vector2(-320,781),
	Vector2(2,2) : Vector2(-501,669),
	Vector2(2,3) : Vector2(-665,521),
	Vector2(2,4) : Vector2(-773,333),
	Vector2(2,5) : Vector2(-833,113),
	Vector2(3,0) : Vector2(90,830),
	Vector2(3,1) : Vector2(302,781),
	Vector2(3,2) : Vector2(482,669),
	Vector2(3,3) : Vector2(645,521),
	Vector2(3,4) : Vector2(754,333),
	Vector2(3,5) : Vector2(814,113)
}

@export var current_resources: Dictionary = {}
@export var star: StarScene


var _buildings: Dictionary = {
	Vector2(0,0) : null,
	Vector2(0,1) : null,
	Vector2(0,2) : null,
	Vector2(0,3) : null,
	Vector2(0,4) : null,
	Vector2(0,5) : null,
	Vector2(1,0) : null,
	Vector2(1,1) : null,
	Vector2(1,2) : null,
	Vector2(1,3) : null,
	Vector2(1,4) : null,
	Vector2(1,5) : null,
	Vector2(2,0) : null,
	Vector2(2,1) : null,
	Vector2(2,2) : null,
	Vector2(2,3) : null,
	Vector2(2,4) : null,
	Vector2(2,5) : null,
	Vector2(3,0) : null,
	Vector2(3,1) : null,
	Vector2(3,2) : null,
	Vector2(3,3) : null
}

var _buildings_under_construction: Array = []

var _num_dyson_swarms: int = 0:
	get = get_num_dyson_swarms


func get_num_dyson_swarms() -> int:
	return _num_dyson_swarms


func _ready() -> void:
	EventBus.tick.connect(_on_game_tick)
	EventBus.resources_extracted.connect(_on_resources_extracted)
	EventBus.constructed.connect(_on_constructed)
	EventBus.construction_requested.connect(_construct)
	EventBus.adjust_hydrogen.connect(_on_adjust_hydrogen)
	EventBus.operational_cost_reported.connect(_on_operational_cost_reported)

	_give_player_resources()
	
	# TODO: Remove after testing!
	#EventBus.star_hydrogen_updated.emit(0, 1000)
	###


func _give_player_resources() -> void:
	current_resources[Constants.BASE_METAL] = 150
	current_resources[Constants.POWER] = 1000
	#current_resources[Constants.HYDROGEN] = 50000


func _construct(building_type: String):
	var next_slot = _find_next_empty_slot()

	if next_slot == null:
		EventBus.feedback_message.emit(MESSAGE_INSUFFICIENT_SPACE)
		return

	var building_to_construct = BuildingFactory.create_building(building_type)

	if not building_to_construct:
		return

	if not building_to_construct.can_be_built_with(current_resources):
		building_to_construct.queue_free()
		EventBus.feedback_message.emit(MESSAGE_INSUFFICIENT_RESOURCES)
		return

	building_to_construct.set_build_speedup_factor(_calculate_building_speedup_factor())

	_deduct_from_current_resources(building_to_construct.building_costs)

	_add_to_build_queue(building_to_construct) # might be moot...

	# planet crackers are built/managed by an assigned planet, so we don't assign it to the
	# scaffold's own buildings
	if building_to_construct.type != Constants.BUILDING_PLANET_CRACKER:
		if( next_slot == null ):
			return # Something went wrong. Bail gracefully

		_buildings[next_slot] = building_to_construct
		building_to_construct.position = BUILD_POS[next_slot]

		add_child( building_to_construct )

	building_to_construct.set_star_scaffold(self)

	EventBus.construction_started.emit(building_to_construct)


func _find_next_empty_slot():
	for pos in _buildings:
		if( _buildings[pos] == null ):
			return pos

	return null


func destroy(building) -> void:
	_buildings.erase(building)
	remove_child(building)


func _on_constructed(building) -> void:
	_buildings_under_construction.erase(building)


func _deduct_from_current_resources(resources_bid: Dictionary) -> void:
	for resource in resources_bid:
		current_resources[resource] -= resources_bid[resource]


func _on_game_tick() -> void:
	EventBus.resources_reported.emit(current_resources)

	if _inoperable_buildings_exist():
		EventBus.feedback_message.emit(MESSAGE_INSUFFICIENT_OPERATING_RESOURCES)

	# TODO: Remove after testing.
	#EventBus.star_hydrogen_updated.emit(current_resources[Constants.HYDROGEN], 1000)


func _inoperable_buildings_exist() -> bool:
	var planets_to_check: Array = get_tree().get_nodes_in_group("PLANET_SCENE").filter(func (p): return p.has_planet_crackers())
	var structures_to_check: Array = []

	for planet in planets_to_check:
		structures_to_check.append_array(planet.get_planet_crackers())

	structures_to_check.append_array(_buildings.values())

	return structures_to_check.any(func (b): return b and not b.is_operating())


func _on_resources_extracted(new_resources: Dictionary) -> void:
	_add_resources(new_resources)
	_check_tier_threshold()

	if new_resources.has(Constants.HYDROGEN):
		_send_hydrogen_to_star(new_resources[Constants.HYDROGEN])


func _on_operational_cost_reported(resources: Dictionary) -> void:
	_remove_resources(resources)


func _check_tier_threshold() -> void:
	if current_resources[Constants.HYDROGEN] >= StellarConstants.get_tier_threshold(star.tier_state):
		pass
		#EventBus.star_transitioned.emit(star.tier_state + 1)


func _add_resources(new_resources: Dictionary) -> void:
	for resource in new_resources:
		current_resources[resource] += new_resources[resource]


func _remove_resources(resources: Dictionary) -> void:
	for resource in resources:
		current_resources[resource] = max(current_resources[resource] - resources[resource], 0)


func _send_hydrogen_to_star(actual_flow: int) -> void:
	var ideal_target_flow: int = StellarConstants.calculate_target_flow(current_resources[Constants.HYDROGEN], star.tier_state)
	var thresholds: Dictionary = StellarConstants.get_tier_state_thresholds(star.tier_state)

	EventBus.hydrogen_flow_updated.emit(
		actual_flow, 
		ideal_target_flow, 
		ideal_target_flow - thresholds.min_flow_tolerance,
		ideal_target_flow + thresholds.max_flow_tolerance
	)


func _add_to_build_queue(building) -> void:
	_buildings_under_construction.append(building)


func _calculate_building_speedup_factor() -> float:
	var speedup_factor: float = 1.0

	for pos in _buildings:
		if( _buildings[pos] == null ):
			continue
		
		if _buildings[pos].type == Constants.BUILDING_GIGAFACTORY and _buildings[pos].is_active:
			speedup_factor += _buildings[pos].build_speedup_factor

	return speedup_factor


func _on_adjust_hydrogen(amount: int) -> void:
	if not current_resources.has(Constants.HYDROGEN):
		return

	current_resources[Constants.HYDROGEN] += amount

	if current_resources[Constants.HYDROGEN] < 0:
		current_resources[Constants.HYDROGEN] = 0
