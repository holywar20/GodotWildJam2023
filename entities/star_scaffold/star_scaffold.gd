class_name StarScaffold
extends Node2D


const MAX_BUILDINGS = 24


var _buildings: Array = []

var _num_dyson_swarms: int = 0:
	get = get_num_dyson_swarms


func get_num_dyson_swarms() -> int:
	return _num_dyson_swarms


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
