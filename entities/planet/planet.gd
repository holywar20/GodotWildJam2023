class_name Planet
extends Node2D

const MAX_RESOURCE_NUMBER = 1000000 # In Gigatons?

const STAR_SIZE = 1500 # In Pixels , max star size, including scaffolding
const ORBIT_SIZE = 2000

@onready var land_masses : ColorRect = $LandMasses
@onready var atmosphere : ColorRect = $Atmosphere

# List of resource types available for this particular planet.
@export_subgroup("Resources")
@export var _resource_abundance: Dictionary = {
	Constants.HYDROGEN: 100000,
	Constants.BASE_METAL: 100000,
	Constants.PRECIOUS_METAL: 100000
}:
	get = get_resource_abundance

@export var flow_rate_dict : Dictionary = {
	Constants.HYDROGEN : 1.0,
	Constants.BASE_METAL : 1.0,
	Constants.PRECIOUS_METAL : 1.0
}

@export_subgroup("Display Params")
@export_enum( "P1" , "P2" , "P3" , "P4" , "P5" , "P6" ) var pid
@export var p_scale : float = 1.0
@export var orbit_num : int = 1.0
@export var orbital_speed : float = 1.0
@export var p_name : String = "Unamed Planet"
@export var p_descript : String = "Lava Planet" 

const RAND_SEED = 11111111
var _rng = RandomNumberGenerator.new()

var _planet_crackers: Array = []

# Mining percentages
var _hydrogen_percentage: float = 0.33:
	get = get_hydrogen_percentage,
	set = set_hydrogen_percentage

var _base_metals_percentage: float = 0.33:
	get = get_base_metals_percentage,
	set = set_base_metals_percentage

var _precious_metals_percentage: float = 0.33:
	get = get_precious_metals_percentage,
	set = set_precious_metals_percentage


func _ready() -> void:
	_rng.seed = RAND_SEED

	EventBus.adjust_hydrogen.connect(_on_adjust_hydrogen)

	set_scale( Vector2( p_scale , p_scale ) )
	_calculate_init_orbit()
	
	# Get initial Parms by planet


func add_planet_cracker(planet_cracker) -> void:
	_planet_crackers.append(planet_cracker)


func remove_planet_cracker() -> void:
	_planet_crackers.pop_back()


func has_planet_crackers() -> bool:
	return _planet_crackers.filter(func (c): return c.is_constructed()).size() > 0


func get_hydrogen_percentage() -> float:
	return _hydrogen_percentage


func set_hydrogen_percentage(value: float) -> void:
	_hydrogen_percentage = value


func get_base_metals_percentage() -> float:
	return _base_metals_percentage


func set_base_metals_percentage(value: float) -> void:
	_base_metals_percentage = value


func get_precious_metals_percentage() -> float:
	return _precious_metals_percentage


func set_precious_metals_percentage(value: float) -> void:
	_precious_metals_percentage = value


func _calculate_init_orbit():
	var dist = STAR_SIZE + ORBIT_SIZE * orbit_num
	var angle = _rng.randf_range( 0 , 2 * PI )
	var pos = Vector2( cos( angle) , sin( angle) ) * dist

	set_global_position( pos )


# Utility Methods
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

func _on_adjust_hydrogen(amount: int) -> void:
	if not _resource_abundance.has(Constants.HYDROGEN):
		return

	_resource_abundance[Constants.HYDROGEN] += amount

	if _resource_abundance[Constants.HYDROGEN] < 0:
		_resource_abundance[Constants.HYDROGEN] = 0

