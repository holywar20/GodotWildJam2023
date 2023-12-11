class_name StarScaffold
extends Node2D


const MAX_BUILDINGS = 24


@export var current_resources: Dictionary = {}

var _buildings: Array = []
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
	
	# TODO: Remove after testing!
	_give_player_resources()


func _give_player_resources() -> void:
	current_resources[Constants.HYDROGEN] = 1000
	current_resources[Constants.BASE_METAL] = 1000
	current_resources[Constants.PRECIOUS_METAL] = 1000


func _construct(building_type: String):
	# This case should never happen as the UI should prevent it.
	if _buildings.size() + 1 >= MAX_BUILDINGS:
		return

	var building_to_construct = BuildingFactory.create_building(building_type)

	if not building_to_construct:
		return

	if not building_to_construct.can_be_built_with(current_resources):
		building_to_construct.queue_free()
		return

	building_to_construct.set_build_speedup_factor(_calculate_building_speedup_factor())

	_deduct_from_current_resources(building_to_construct.building_costs)

	_add_to_build_queue(building_to_construct)

	_buildings.append(building_to_construct)
	add_child(building_to_construct)

	EventBus.construction_started.emit(building_to_construct)


func destroy(building) -> void:
	_buildings.erase(building)
	building.queue_free()


func _on_constructed(building) -> void:
	_buildings_under_construction.erase(building)


func _deduct_from_current_resources(resources_bid: Dictionary) -> void:
	for resource in resources_bid:
		current_resources[resource] -= resources_bid[resource]


func _on_game_tick() -> void:
	EventBus.resources_reported.emit(current_resources)

	if _buildings_under_construction:
		EventBus.build_queue.emit(_buildings_under_construction)


func _on_resources_extracted(new_resources: Dictionary) -> void:
	_add_resources(new_resources)


func _add_resources(new_resources: Dictionary) -> void:
	for resource in new_resources:
		current_resources[resource] += new_resources[resource]


func _add_to_build_queue(building) -> void:
	_buildings_under_construction.append(building)


func _calculate_building_speedup_factor() -> float:
	var speedup_factor: float = 0.0

	for building in _buildings:
		if building.type == Constants.BUILDING_GIGAFACTORY:
			speedup_factor += building.build_speedup_factor

	return speedup_factor
