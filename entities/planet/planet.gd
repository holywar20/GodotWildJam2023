class_name Planet
extends Node2D

const LAND_MASS_SHADER = preload("res://entities/planet/LandMasses.gdshader")
const ATMOSPHERE_SHADER = preload("res://entities/planet/NormalClouds.gdshader")
const GAS_GIANT_SHADER = preload("res://entities/planet/GasGiantClouds.gdshader")

const MAX_RESOURCE_NUMBER = 1000000 # In Gigatons?

const STAR_SIZE = 1500 # In Pixels , max star size, including scaffolding
const ORBIT_SIZE = 2000

const MAX_PLANET_CRACKERS = 5

var radians72 = 72.0 * PI / 180.0
var cracker_placements = {
   0: 0.0,
   1: 72.0 * radians72,
   2: 144.0 * radians72,
   3: 216.0 * radians72,
   4: 288.0 * radians72
}

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

var resource_backup

@export var flow_rate_dict : Dictionary = {
	Constants.HYDROGEN : 1.0,
	Constants.BASE_METAL : 1.0,
	Constants.PRECIOUS_METAL : 1.0
}

@export_subgroup("Display Params")
@export_enum( "P1" , "P2" , "P3" , "P4" , "P5" , "P6" ) var pid : String = "P1"
@export var p_scale : float = 1.0
@export var orbit_num : int = 1
@export var orbital_speed : float = 1.0
@export var p_name : String = "Unamed Planet"
@export var p_class : String = "Lava Planet"
@export var p_descript : String = "" 
@export var is_icon : bool = false


var has_lasers : bool = false

const RAND_SEED = 11111111
var _rng = RandomNumberGenerator.new()

var _planet_crackers: Array = []:
	get = get_planet_crackers

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
	resource_backup = {}
	for key in _resource_abundance:
		var value = _resource_abundance[key]
		resource_backup[key] = value

	if( !is_icon ):
		set_scale( Vector2( p_scale , p_scale ) )
		_calculate_init_orbit()

		# Get initial Parms by planet
		var shaderParams = PlanetaryConstants.get_shader_params( pid )
		decoratePlanet( shaderParams , true )
	else:
		remove_from_group("PLANET_SCENE")
		show()

func fire_laser() -> void:
	pass

func set_as_icon( n_pid : String ) -> void:
	var shaderParams = PlanetaryConstants.get_shader_params( n_pid )
	forceDecorate( shaderParams , n_pid )

func add_planet_cracker(planet_cracker) -> void:
	var cracker_count = _planet_crackers.size()
	
	# This is a bug, shouldnt' be callable, but just so the interface doesn't break.
	if( cracker_count >= 5 ):
		return

	var radians = cracker_placements[cracker_count]

	planet_cracker.set_rotation( radians )
	var unit_circle = Vector2( cos(radians),  sin(radians) )
	# Since planets are already scaled, just need to set local coordinates to half planet size ( radius ) , an offset to make it all line up.
	var nPosition = unit_circle * ( 250 + 100 )
	planet_cracker.set_position( nPosition )

	add_child(planet_cracker)

	_planet_crackers.append(planet_cracker)

func remove_planet_cracker() -> void:
	var this_cracker = _planet_crackers.pop_back()

	remove_child(this_cracker)
	this_cracker.queue_free()

func has_planet_crackers() -> bool:
	return _planet_crackers.filter(func (c): return c.is_constructed()).size() > 0

func get_planet_crackers() -> Array:
	return _planet_crackers

func has_room_for_crackers() -> bool:
	return get_planet_crackers().size() < MAX_PLANET_CRACKERS

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

func reset_resources():
	for key in _resource_abundance:
		_resource_abundance[key] = resource_backup[key]
	
	for cracker in _planet_crackers:
		remove_child(cracker)

	_planet_crackers = []

# Utility Methods
# Returns the amount extracted, if any.
func extract_resource(resource: UsableResource) -> int:
	if not flow_rate_dict[resource]:
		return 0

	var amount_to_extract: int = roundi(_get_resource_percentage(resource) * flow_rate_dict[resource])

	if _resource_abundance[resource] < amount_to_extract:
		var amount_extracted: int = _resource_abundance[resource]
		_resource_abundance[resource] = 0
		return amount_extracted

	if resource == Constants.HYDROGEN and _resource_abundance[resource] <= 1000 and _resource_abundance[resource] != 0:
		EventBus.emit_signal("planet_depletion",  self)

	_resource_abundance[resource] -= amount_to_extract
	return amount_to_extract


func _get_resource_percentage(resource: UsableResource) -> float:
	match resource:
		Constants.HYDROGEN:
			return get_hydrogen_percentage()
		Constants.BASE_METAL:
			return get_base_metals_percentage()
		Constants.PRECIOUS_METAL:
			return get_precious_metals_percentage()

	return 1.0


func get_resource_abundance() -> Dictionary:
	return _resource_abundance

# Shader methods

# Bit of a hack so we can get icons to work without using export params
func forceDecorate( paramsDict , n_pid : String ) -> void:
	pid = n_pid
	
	decoratePlanet( paramsDict, true )

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

func _update_landmass_shader( paramDict : Dictionary ):
	for prop in paramDict['landMasses']:
		land_mat.set_shader_parameter( prop , paramDict['landMasses'][prop] )

func _update_atmoshader_shader( paramDict : Dictionary ):
	for prop in paramDict['atmo']:
		atmos_mat.set_shader_parameter( prop , paramDict['atmo'][prop] )

func _update_gasgiant_shader( paramDict : Dictionary ):
	for prop in paramDict['gasAtmo']:
		gas_mat.set_shader_parameter( prop , paramDict['gasAtmo'][prop] )
