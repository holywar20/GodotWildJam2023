class_name Planet
extends Node2D

const LAND_MASS_SHADER = preload("res://entities/planet/LandMasses.gdshader")
const ATMOSPHERE_SHADER = preload("res://entities/planet/NormalClouds.gdshader")
const GAS_GIANT_SHADER = preload("res://entities/planet/GasGiantClouds.gdshader")

const MAX_RESOURCE_NUMBER = 1000000 # In Gigatons?

const STAR_SIZE = 1500 # In Pixels , max star size, including scaffolding
const ORBIT_SIZE = 2000

@onready var land_masses : ColorRect = $LandMasses
@onready var atmosphere : ColorRect = $Atmosphere
@onready var gas_atmo : ColorRect = $GasAtmo

var land_mat : ShaderMaterial
var atmos_mat : ShaderMaterial
var gas_mat : ShaderMaterial

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
@export_enum( "P1" , "P2" , "P3" , "P4" , "P5" , "P6" ) var pid : String = "P1"
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

	set_scale( Vector2( p_scale , p_scale ) )
	_calculate_init_orbit()

	# Get initial Parms by planet
	var shaderParams = PlanetaryConstants.get_shader_params( pid )
	decoratePlanet( shaderParams , true )

func add_planet_cracker(planet_cracker) -> void:
	add_child(planet_cracker)
	_planet_crackers.append(planet_cracker)

func remove_planet_cracker() -> void:
	remove_child(_planet_crackers.pop_back())

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

# Shader methods

func decoratePlanet( paramsDict , initLoad = false ):
	var isGas = false
	if( pid == PlanetaryConstants.PIDS.P4 || pid == PlanetaryConstants.PIDS.P5 ):
		isGas = true

	if( isGas ):
		if( initLoad ):
			land_masses.hide()
			atmosphere.hide()

			gas_atmo.show()

			gas_mat = ShaderMaterial.new()
			gas_mat.set_shader( GAS_GIANT_SHADER )
			gas_atmo.set_material( gas_mat )

			var gasTexture = PlanetaryConstants.get_cloud_gradient( pid )
			gas_mat.set_shader_parameter( "colorBands" , gasTexture )

		_update_gasgiant_shader( paramsDict  )
	else:
		if( initLoad ):
			land_masses.show()
			atmosphere.show()

			gas_atmo.hide()

			land_mat = ShaderMaterial.new()
			land_mat.set_shader( LAND_MASS_SHADER )
			land_masses.set_material( land_mat )

			var seedTexture = PlanetaryConstants.get_seed_texture( pid )
			land_mat.set_shader_parameter( "seedTexture" , seedTexture )

			var oceanTexture = PlanetaryConstants.get_ocean_texture( pid )
			land_mat.set_shader_parameter( "oceanColorMap" , oceanTexture )

			var seedBumpTexture = PlanetaryConstants.get_bump_texture( pid )
			land_mat.set_shader_parameter( "seedBumpMap" , seedBumpTexture )

			var ridgeBumpMap = PlanetaryConstants.get_ridge_texture( pid )
			land_mat.set_shader_parameter( "ridgeBumpMap" , ridgeBumpMap )

			var heightMap = PlanetaryConstants.get_gradient_texture( pid )
			land_mat.set_shader_parameter( "heightMap" , heightMap )
			land_mat.set_shader_parameter( "isMap" , false )

			atmos_mat = ShaderMaterial.new()
			atmos_mat.set_shader( ATMOSPHERE_SHADER )
			atmosphere.set_material( atmos_mat )

			var cloudGradient = PlanetaryConstants.get_cloud_gradient( pid )
			if( cloudGradient != null ):
				atmos_mat.set_shader_parameter( "cloudGradient" , cloudGradient )

		_update_landmass_shader( paramsDict )
		_update_atmoshader_shader( paramsDict )
		# _update_gasgiant_shader( paramsDict , null )

func _update_landmass_shader( paramDict : Dictionary ):
	for prop in paramDict['landMasses']:
		land_mat.set_shader_parameter( prop , paramDict['landMasses'][prop] )

func _update_atmoshader_shader( paramDict : Dictionary ):
	for prop in paramDict['atmo']:
		atmos_mat.set_shader_parameter( prop , paramDict['atmo'][prop] )

func _update_gasgiant_shader( paramDict : Dictionary ):
	for prop in paramDict['gasAtmo']:
		gas_mat.set_shader_parameter( prop , paramDict['gasAtmo'][prop] )
