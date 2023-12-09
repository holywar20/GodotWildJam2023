class_name AbstractBuilding
extends Node2D


enum Tiers {
	TIER_1,
	TIER_2,
	TIER_3,
}


@export var type: String = ""
@export var is_active: bool = false
@export var tier: Tiers = Tiers.TIER_1

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


func can_be_built_with(resource_bid: Dictionary) -> bool:
	for resource in building_costs:
		if not resource_bid.has(resource) or resource_bid[resource] < building_costs[resource]:
			return false

	return true
