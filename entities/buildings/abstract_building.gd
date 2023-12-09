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


var _is_constructed: bool = false
var _build_progress: int = 0


func can_be_built_with(resource_bid: Dictionary) -> bool:
	for resource in building_costs:
		if not resource_bid.has(resource) or resource_bid[resource] < building_costs[resource]:
			return false

	return true


func _process(_delta):
	if not _is_constructed:
		_build_progress += 1

	if _build_progress >= build_time:
		_build_progress = 0
		_is_constructed = true
		is_active = true
