class_name Planet
extends Node2D


const MAX_RESOURCE_NUMBER = 1000000 # In Gigatons?


# List of resource types available for this particular planet.
@export_subgroup("Resources")
@export var resources_available: Array = []

@export_subgroup("Display Params")
@export_enum( "P1" , "P2" , "P3" , "P4" , "P5" , "P6" ) var pid

var _resource_abundance: Dictionary = {}:
	get = get_resource_abundance

var _num_planet_crackers: int = 0


func _ready() -> void:
	randomize()
	_randomize_resource_availability()

# Returns the amount extracted, if any.
func extract_resource(resource: UsableResource, amount_requested: int) -> int:
	if _resource_abundance[resource] < amount_requested:
		var amount_extracted: int = _resource_abundance[resource]
		_resource_abundance[resource] = 0
		return amount_extracted

	_resource_abundance[resource] -= amount_requested
	return amount_requested

func get_resource_abundance() -> Dictionary:
	return _resource_abundance

func _randomize_resource_availability() -> void:
	for resource in resources_available:
		_resource_abundance[resource] = randi_range(0, MAX_RESOURCE_NUMBER)
