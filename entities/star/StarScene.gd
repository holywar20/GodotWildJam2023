extends Node2D
class_name StarScene

# Should be less than the resource tick
const TWEEN_DURATION : float = 4.0

# Teir props
var tier_state = Constants.Tiers.TIER_0
var nteir_progress : float = 0.0
var star_class : String = "Not assigned"
var description : String = "Not assigned"

# Dynamic props
var temperature : float = 0
var luminosity : float = 0
var mass : float = 0

var over_input_threshold : float = 0.0
var under_input_threshold : float = 0.0
var current_shader_props = {
	'star_body' : {},
	'corona' : {}
}

# Materials and childen
@onready var corona : ColorRect = $Corona
@onready var star_body : ColorRect = $StarBody

var corona_mat : ShaderMaterial
var starbody_mat : ShaderMaterial

var target_shader_values : Dictionary = {}

func _ready() -> void:
	var starState = StellarConstants.get_tier_state( tier_state )

	corona_mat = $Corona.get_material()
	starbody_mat = $StarBody.get_material()
	
	_init_data_write( starState )

	# Testing
	_apply_size_change( 1.0 )

func _on_resources_reported( resources : Array ):
	pass

func _init_data_write( data : Dictionary ) -> void:
	# Metadata
	star_class = data.metadata.star_class
	description = data.metadata.description

	var gradient_base = starbody_mat.get_shader_parameter( "gradient" )
	gradient_base.set_gradient( data.metadata.gradient )

	# Interpolated Metadata
	temperature = data.interpolated_metadata.temperature
	luminosity = data.interpolated_metadata.luminosity
	mass = data.interpolated_metadata.mass
	set_scale( Vector2( data.interpolated_metadata.scale , data.interpolated_metadata.scale ) )

	# Corona and star body
	for prop in data.corona:
		corona_mat.set_shader_parameter( prop, data.corona[prop] )
		current_shader_props.corona[prop] = data.corona[prop]
	
	for prop in data.star_body:
		starbody_mat.set_shader_parameter( prop, data.star_body[prop] )
		current_shader_props.star_body[prop] = data.star_body[prop]

func _apply_size_change( percent_change : float ):
	if( tier_state == Constants.Tiers.TIER_3 ):
		return # Star is at the final state, so we don't need to apply size changes anymore.

	var current_tier_data = StellarConstants.get_tier_state( tier_state )
	var next_tier_data = StellarConstants.get_tier_state( tier_state + 1 )
	var tween_data = StellarConstants.get_blank_tier_data()

	# Calculate all the non-meta_data interpolated values
	for dict_key in current_tier_data:
		if( dict_key == "metadata" ):
			continue
		
		for prop_key in current_tier_data[dict_key]:
			var current_value = current_tier_data[dict_key][prop_key]
			var next_value = next_tier_data[dict_key][prop_key]

			var interpolated_value = current_value + ( ( next_value - current_value ) * percent_change )

			tween_data[dict_key][prop_key] = interpolated_value

	# Create a new tween
	var star_tween = get_tree().create_tween()
	
	# Handle scale manually
	var s = Vector2( tween_data.interpolated_metadata.scale, tween_data.interpolated_metadata.scale )
	star_tween.tween_property( self , "scale" , s , TWEEN_DURATION )

	var s_cur = current_shader_props.star_body
	var s_tar = tween_data.star_body
	
	# Now use the tween method to apply all the shader values
	star_tween.parallel().tween_method( _set_convectionSpeed, s_cur.convectionSpeed , s_tar.convectionSpeed , TWEEN_DURATION );
	star_tween.parallel().tween_method( _set_rotationSpeed, s_cur.rotationSpeed , s_tar.rotationSpeed , TWEEN_DURATION );
	star_tween.parallel().tween_method( _set_stretchFactor, s_cur.stretchFactor , s_tar.stretchFactor , TWEEN_DURATION );
	star_tween.parallel().tween_method( _set_wormCellSize, s_cur.wormCellSize , s_tar.wormCellSize , TWEEN_DURATION );
	star_tween.parallel().tween_method( _set_vorCellSize, s_cur.vorCellSize , s_tar.vorCellSize , TWEEN_DURATION );
	star_tween.parallel().tween_method( _set_flowFactor, s_cur.flowFactor , s_tar.flowFactor , TWEEN_DURATION );
	star_tween.parallel().tween_method( _set_cellSize, s_cur.cellSize , s_tar.cellSize , TWEEN_DURATION );
	
	var c_cur = current_shader_props.corona
	var c_tar = tween_data.corona

	# Handle the Corona
	star_tween.parallel().tween_method( _set_flareAmount, c_cur.flareAmount , c_tar.flareAmount , TWEEN_DURATION );
	star_tween.parallel().tween_method( _set_timeFactor, c_cur.timeFactor , c_tar.timeFactor , TWEEN_DURATION );
	star_tween.parallel().tween_method( _set_spiky, c_cur.spiky , c_tar.spiky , TWEEN_DURATION );
	star_tween.parallel().tween_method( _set_color, c_cur.color , c_tar.color , TWEEN_DURATION );
	star_tween.parallel().tween_method( _set_csize, c_cur.size , c_tar.size , TWEEN_DURATION );
	star_tween.parallel().tween_method( _set_gas, c_cur.gas , c_tar.gas , TWEEN_DURATION );

	star_tween.play()

	# Fire the new properties so front end can consume it.
	EventBus.emit_signal( "star_size_changed", tween_data.interpolated_metadata )

	# Now we update the current so next tick has this data.
	current_shader_props = tween_data


# Corona tween methods 
func _set_color( value : Vector3 ) -> void:
	corona_mat.set_shader_parameter("color", value);

func _set_timeFactor( value : float ) -> void:
	corona_mat.set_shader_parameter("timeFactor", value);

func _set_flareAmount( value : float ) -> void:
	corona_mat.set_shader_parameter("flareAmount", value);

func _set_csize( value : float ) -> void:
	corona_mat.set_shader_parameter("size", value);

func _set_spiky( value : float ) -> void:
	corona_mat.set_shader_parameter("spiky", value);

func _set_gas( value : float ) -> void:
	corona_mat.set_shader_parameter("gas", value);

# Star_body tween methods
# Stupid thing I hafta do because tweening dynamic shader properties doesn't seem to be supported
func _set_wormCellSize( value : float ) -> void:
	starbody_mat.set_shader_parameter("wormCellSize", value);

func _set_rotationSpeed( value : float ) -> void:
	starbody_mat.set_shader_parameter("rotationSpeed", value);

func _set_cellSize(	value : float ) -> void:
	starbody_mat.set_shader_parameter("cellSize", value);

func _set_flowFactor( value : float ) -> void:
	starbody_mat.set_shader_parameter("flowFactor", value);

func _set_vorCellSize( value : float ) -> void:
	starbody_mat.set_shader_parameter("vorCellSize", value);

func _set_convectionSpeed( value : float ) -> void:
	starbody_mat.set_shader_parameter("convectionSpeed", value);

func _set_stretchFactor( value : float ) -> void:
	starbody_mat.set_shader_parameter("stretchFactor", value);
