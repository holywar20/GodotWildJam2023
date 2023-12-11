class_name AbstractBuilding
extends Node2D


@export var type: String = ""
@export var is_active: bool = false
@export var tier: Constants.Tiers = Constants.Tiers.TIER_1

# Build time in base unit of time.
@export var build_time: int

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

var _build_speed_factor: float = 1.0:
	set = set_build_speedup_factor

var _is_constructed: bool = false
var _build_progress: float = 0.0


func _ready() -> void:
	EventBus.tick.connect(_on_game_tick)


func set_build_speedup_factor(value: float) -> void:
	_build_speed_factor = value


func can_be_built_with(resource_bid: Dictionary) -> bool:
	for resource in building_costs:
		if not resource_bid.has(resource) or resource_bid[resource] < building_costs[resource]:
			return false

	return true


func get_construction_complete_percentage() -> float:
	return _build_progress / build_time


func _process(_delta) -> void:
	if not _is_constructed:
		_build_progress += GameTime.scale + _build_speed_factor

		if _build_progress >= build_time:
			_build_progress = 0.0
			_is_constructed = true
			is_active = true
			signal_constructed()


func _on_game_tick():
	#if not _is_constructed:
		#_build_progress += GameTime.scale + _build_speed_factor
#
		#if _build_progress >= build_time:
			#_build_progress = 0.0
			#_is_constructed = true
			#is_active = true
			#signal_constructed()
#
		#return

	# Report on resource extraction/changes
	if produces:
		EventBus.resources_extracted.emit(next_extraction())


func signal_constructed():
	if type == Constants.BUILDING_DYSON_SWARM:
		EventBus.dyson_construction_finished.emit()
	else:
		EventBus.constructed.emit(self)


func next_extraction() -> Dictionary:
	return produces
