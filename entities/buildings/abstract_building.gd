class_name AbstractBuilding
extends Node2D


@export var type: String = ""
@export var is_active: bool = false
@export var tier: Constants.Tiers = Constants.Tiers.TIER_1

# In seconds
@export var build_time: int

# Building description shown in UI elements
@export var description: String = ""

# Dictates per unit time resource costs.
# Key: UsableResource
# Value: Number of resources per unit time to deduct
@export var operational_costs: Dictionary

# Dictates resource requirements to build.
# Key: UsableResource
# Value: Number of resources required to build
@export var building_costs: Dictionary

# Determines per unit time production values.
# Key: UsableResource
# Value: Number of resources per unit time to produce
@export var produces: Dictionary

var _is_operating: bool = true:
	get = is_operating


# the star scaffold that owns this building, if relevant
var _star_scaffold: StarScaffold = null:
	set = set_star_scaffold


@onready var building_sprite = $Building

var _build_speed_factor: float = 1.0:
	set = set_build_speedup_factor

var _is_constructed: bool = false:
	get = is_constructed

var _build_progress: float = 0.0

var main_sprite
var construction_sprite


func _ready() -> void:
	tree_exited.connect(_on_tree_exited)
	EventBus.tick.connect(_on_game_tick)
	_set_nodes()


func _set_nodes() -> void:
	main_sprite = $Building
	construction_sprite = $Construction
	
	construction_sprite.show()
	main_sprite.hide()


func set_star_scaffold(value: StarScaffold) -> void:
	_star_scaffold = value


func set_build_speedup_factor(value: float) -> void:
	_build_speed_factor = value


func is_constructed() -> bool:
	return _is_constructed


func is_operating() -> bool:
	return _is_operating


func can_be_built_with(resource_bid: Dictionary) -> bool:
	for resource in building_costs:
		if not resource_bid.has(resource) or resource_bid[resource] < building_costs[resource]:
			return false

	return true


func get_construction_complete_percentage() -> float:
	return _build_progress / build_time


func _process(delta) -> void:
	if not _is_constructed:
		_build_progress += delta * GameTime.scale * _build_speed_factor

		if _build_progress >= build_time:
			_build_progress = 0.0
			_is_constructed = true
			is_active = true
			post_constructed()
			signal_constructed()


func _on_game_tick():
	# Report on resource extraction/changes
	if is_active:
		# if the player doesn't have enough current resources to run this building,
		# then skip any extraction
		_is_operating = _can_operate()

		if not _is_operating:
			return

		EventBus.resources_extracted.emit(next_extraction())
		EventBus.operational_cost_reported.emit(get_operational_cost())


func _can_operate() -> bool:
	if not _star_scaffold:
		return true

	var player_resources: Dictionary = _star_scaffold.current_resources
	for resource in operational_costs:
		if not player_resources.has(resource):
			return false

		if player_resources[resource] - operational_costs[resource] < 0:
			return false

	return true


func signal_constructed():
	if type == Constants.BUILDING_DYSON_SWARM:
		EventBus.dyson_construction_finished.emit()
	else:
		EventBus.constructed.emit(self)
		
		construction_sprite.hide()
		main_sprite.show()


func next_extraction() -> Dictionary:
	return produces if produces else {}


func get_operational_cost() -> Dictionary:
	return operational_costs if operational_costs else {}


func post_constructed() -> void:
	pass


func _on_tree_exited() -> void:
	queue_free()
