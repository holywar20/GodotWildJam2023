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

var star_hydrogen : float = 0

var current_tick = {
	'max_threshold' : 1.0,
	'min_threshold' : 0.0
}

var current_shader_props = {
	'star_body' : {},
	'corona' : {},
	'gradient' : []
}

# Materials and childen
@onready var corona : ColorRect = $Corona
@onready var star_body : ColorRect = $StarBody

var corona_mat : ShaderMaterial
var starbody_mat : ShaderMaterial

var target_shader_values : Dictionary = {}

# target hydrogen values
# TODO: use proper values and increments
var _min_target: int = 0
var _max_target: int = 50

func _ready() -> void:
	current_shader_props = StellarConstants.get_tier_state( tier_state )
	
	corona_mat = $Corona.get_material()
	starbody_mat = $StarBody.get_material()
	
	_init_data_write( current_shader_props )

	EventBus.connect( "resources_reported", Callable( self, "_on_resources_reported" ) )
	EventBus.connect( "tick", Callable( self, "_on_tick" ) )

func _on_tick() -> void:
	EventBus.star_hydrogen_target_updated.emit(_min_target, _max_target)
	_min_target += 100
	_max_target += 100


func _on_resources_reported( resources : Dictionary ) -> void:
	star_hydrogen = resources[Constants.HYDROGEN]
	var percent_change = StellarConstants.get_tier_percent_diff( star_hydrogen , tier_state , tier_state + 1 )
	# await get_tree().create_timer(5.0).timeout
	# _apply_size_change( 1.0 )


func _init_data_write( data : Dictionary ) -> void:
	# Metadata
	star_class = data.metadata.star_class
	description = data.metadata.description

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

	for p_type in data.gradient:
		for idx in range( 0 , data.gradient[p_type].size() ):
			var prop = data.gradient[p_type][idx]
			current_shader_props.gradient[p_type][idx] = prop

	EventBus.emit_signal( "star_size_changed", data.interpolated_metadata )

# This method interpolates values on the basis of current and next tiers.
# these numbers are then used in a tween to apply a more fine grained interpolation designed to sync up with resource tics.
func _apply_size_change( percent_change : float ):
	if( tier_state == Constants.Tiers.TIER_3 ):
		return # Star is at the final state, so we don't need to apply size changes anymore.
	
	var next_tier_data = StellarConstants.get_tier_state( tier_state + 1 )
	var tween_data = StellarConstants.get_blank_tier_data()

	# Metadata properties
	for prop in current_shader_props.interpolated_metadata:
		if( prop == 'scale' ):
			continue # Scale is handled manually

		var current_value = current_shader_props.interpolated_metadata[prop]
		var next_value = next_tier_data.interpolated_metadata[prop]

		var interpolated_value = current_value + ( ( next_value - current_value ) * percent_change )

		tween_data.interpolated_metadata[prop] = interpolated_value

	# Star body interpolation
	for prop in current_shader_props.star_body:
		var current_value = current_shader_props.star_body[prop]
		var next_value = next_tier_data.star_body[prop]

		var interpolated_value = current_value + ( ( next_value - current_value ) * percent_change )

		tween_data.star_body[prop] = interpolated_value
		
	# Handling the Corona
	for prop in current_shader_props.corona:
		var current_value = current_shader_props.corona[prop]
		var next_value = next_tier_data.corona[prop]

		var interpolated_value = current_value + ( ( next_value - current_value ) * percent_change )

		tween_data.corona[prop] = interpolated_value

	# Handling gradients - structure is assumed to be dictionary -> array -> value
	for p_type in current_shader_props.gradient:
		tween_data.gradient[p_type] = []
		
		for idx in range( 0 , current_shader_props.gradient[p_type].size() ):
			var current_value = current_shader_props.gradient[p_type][idx]
			var next_value = next_tier_data.gradient[p_type][idx]

			var interpolated_value = current_value + ( ( next_value - current_value ) * percent_change )

			tween_data.gradient[p_type].append( interpolated_value )

	# Create a new tween
	var star_tween = get_tree().create_tween()
	
	# Handle scale manually cuz it needs a vec2, and is the only interpolated_property that requires tweening
	var s = Vector2( tween_data.interpolated_metadata.scale, tween_data.interpolated_metadata.scale )
	star_tween.tween_property( self , "scale" , s , TWEEN_DURATION )

	var s_cur = current_shader_props.star_body
	var s_tar = tween_data.star_body
	
	# Now use the tween method to apply all the shader values
	star_tween.parallel().tween_method( _set_convectionSpeed, s_cur.convectionSpeed , s_tar.convectionSpeed , TWEEN_DURATION )
	star_tween.parallel().tween_method( _set_rotationSpeed, s_cur.rotationSpeed , s_tar.rotationSpeed , TWEEN_DURATION )
	star_tween.parallel().tween_method( _set_stretchFactor, s_cur.stretchFactor , s_tar.stretchFactor , TWEEN_DURATION )
	star_tween.parallel().tween_method( _set_wormCellSize, s_cur.wormCellSize , s_tar.wormCellSize , TWEEN_DURATION )
	star_tween.parallel().tween_method( _set_vorCellSize, s_cur.vorCellSize , s_tar.vorCellSize , TWEEN_DURATION )
	star_tween.parallel().tween_method( _set_flowFactor, s_cur.flowFactor , s_tar.flowFactor , TWEEN_DURATION )
	star_tween.parallel().tween_method( _set_cellSize, s_cur.cellSize , s_tar.cellSize , TWEEN_DURATION )
	
	var c_cur = current_shader_props.corona
	var c_tar = tween_data.corona

	# Handle the Corona
	star_tween.parallel().tween_method( _set_flareAmount, c_cur.flareAmount , c_tar.flareAmount , TWEEN_DURATION )
	star_tween.parallel().tween_method( _set_timeFactor, c_cur.timeFactor , c_tar.timeFactor , TWEEN_DURATION )
	star_tween.parallel().tween_method( _set_spiky, c_cur.spiky , c_tar.spiky , TWEEN_DURATION )
	star_tween.parallel().tween_method( _set_color, c_cur.color , c_tar.color , TWEEN_DURATION )
	star_tween.parallel().tween_method( _set_csize, c_cur.size , c_tar.size , TWEEN_DURATION )
	star_tween.parallel().tween_method( _set_gas, c_cur.gas , c_tar.gas , TWEEN_DURATION )

	var c_grad = current_shader_props.gradient
	var t_grad = tween_data.gradient

	# Now do the gradient. Worst code in this whole project. rage.
	star_tween.parallel().tween_method( _set_grad_c0 , c_grad.colors[0]  , t_grad.colors[0]   , TWEEN_DURATION )
	star_tween.parallel().tween_method( _set_grad_c1 , c_grad.colors[1]   ,t_grad.colors[1]   , TWEEN_DURATION )
	star_tween.parallel().tween_method( _set_grad_c2 , c_grad.colors[2]  , t_grad.colors[2]  , TWEEN_DURATION )
	star_tween.parallel().tween_method( _set_grad_c3 , c_grad.colors[3]  , t_grad.colors[3]  , TWEEN_DURATION )
	star_tween.parallel().tween_method( _set_grad_c4 , c_grad.colors[4]  , t_grad.colors[4]  , TWEEN_DURATION )

	star_tween.parallel().tween_method( _set_grad_o0 , c_grad.offsets[0]  , t_grad.offsets[0]  , TWEEN_DURATION )
	star_tween.parallel().tween_method( _set_grad_o1 , c_grad.offsets[1]  , t_grad.offsets[1]  , TWEEN_DURATION )
	star_tween.parallel().tween_method( _set_grad_o2 , c_grad.offsets[2]  , t_grad.offsets[2]  , TWEEN_DURATION )
	star_tween.parallel().tween_method( _set_grad_o3 , c_grad.offsets[3]  , t_grad.offsets[3]  , TWEEN_DURATION )
	star_tween.parallel().tween_method( _set_grad_o4 , c_grad.offsets[4]  , t_grad.offsets[4]  , TWEEN_DURATION )

	star_tween.play()

	# Fire the new properties so front end can consume it.
	EventBus.emit_signal( "star_size_changed", tween_data.interpolated_metadata )

	# Now we update the current so next tick has this data.
	await get_tree().create_timer(4.0).timeout
	current_shader_props = tween_data


# Gradient Properties
# Stupid thing I hafta do because tweening dynamic shader properties doesn't seem to be supported
func _set_grad_c0( value : Vector3 ) -> void:
	starbody_mat.get_shader_parameter( "gradient" ).get_gradient().set_color( 0 , Color( value.x , value.y, value.z ) )

func _set_grad_c1( value : Vector3 ) -> void:
	starbody_mat.get_shader_parameter( "gradient" ).get_gradient().set_color( 1 , Color( value.x , value.y, value.z ) )

func _set_grad_c2( value : Vector3 ) -> void:
	starbody_mat.get_shader_parameter( "gradient" ).get_gradient().set_color( 2 , Color( value.x , value.y, value.z ) )

func _set_grad_c3( value : Vector3 ) -> void:
	starbody_mat.get_shader_parameter( "gradient" ).get_gradient().set_color( 3 , Color( value.x , value.y, value.z ) )

func _set_grad_c4( value : Vector3 ) -> void:
	starbody_mat.get_shader_parameter( "gradient" ).get_gradient().set_color( 4 , Color( value.x , value.y, value.z ) )

func _set_grad_o0( value : float ) -> void:
	starbody_mat.get_shader_parameter( "gradient" ).get_gradient().set_offset( 0 , value )

func _set_grad_o1( value : float ) -> void:
	starbody_mat.get_shader_parameter( "gradient" ).get_gradient().set_offset( 1 , value )

func _set_grad_o2( value : float ) -> void:
	starbody_mat.get_shader_parameter( "gradient" ).get_gradient().set_offset( 2 , value )

func _set_grad_o3( value : float ) -> void:
	starbody_mat.get_shader_parameter( "gradient" ).get_gradient().set_offset( 3 , value )

func _set_grad_o4( value : float ) -> void:
	starbody_mat.get_shader_parameter( "gradient" ).get_gradient().set_offset( 4 , value )

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
