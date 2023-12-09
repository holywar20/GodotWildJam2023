class_name StarScaffold
extends Node2D


const MAX_BUILDINGS = 24


@export var current_resources: Dictionary = {}

var _buildings: Array = []

var _num_dyson_swarms: int = 0:
	get = get_num_dyson_swarms


func get_num_dyson_swarms() -> int:
	return _num_dyson_swarms


func _ready() -> void:
	EventBus.tick.connect(_on_game_tick)
	EventBus.resources_extracted.connect(_on_resources_extracted)


func construct_building(building_type: String, resource_bid: Dictionary):
	# This case should never happen as the UI should prevent it.
	if _buildings.size() + 1 >= MAX_BUILDINGS:
		return

	var building_to_construct = BuildingFactory.create_building(building_type)

	if not building_to_construct:
		return

	if not building_to_construct.can_be_built_with(resource_bid):
		building_to_construct.queue_free()
		return

	_buildings.append(building_to_construct)
	add_child(building_to_construct)


func _on_game_tick() -> void:
	EventBus.resources_reported.emit(current_resources)


func _on_resources_extracted(new_resources: Dictionary) -> void:
	_add_resources(new_resources)


func _add_resources(new_resources: Dictionary) -> void:
	for resource in new_resources:
		current_resources[resource] += new_resources[resource]

