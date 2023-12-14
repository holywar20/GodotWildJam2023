extends Node2D
class_name StarScene

# Should be less than the resource tick
const TWEEN_DURATION : float = 4.0

# Tier props
var tier_state = Constants.Tiers.TIER_0
var nteir_progress : float = 0.0
var star_class : String = "Not assigned"
var description : String = "Not assigned"

# Dynamic props
var temperature : float = 0
var luminosity : float = 0
var mass : float = 0

var star_hydrogen : float = 10000

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
var starbody_gradient

@export var star_active : bool = true

func _ready() -> void:
	current_shader_props = StellarConstants.get_tier_state( tier_state )
	
	corona_mat = $Corona.get_material()
	starbody_mat = $StarBody.get_material()

	# Note - we want material/shader/gradient1d/gradienttexture - gradients in shaders are nested inside another resource 
	starbody_gradient = starbody_mat.get_shader_parameter( "gradient" ).get_gradient()
	
	_init_data_write( current_shader_props )
	_shader_data_write( current_shader_props )

	if( star_active ):
		EventBus.connect( "resources_reported" , Callable(self, "_on_resources_reported") )

func _on_resources_reported( resources : Dictionary ) -> void:
	if( tier_state == Constants.Tiers.TIER_3 ):
		return # Star is at the final state, so we don't need to apply size changes anymore.
	
	var next_hydrogen = resources[Constants.HYDROGEN]
	if( next_hydrogen == star_hydrogen ):
		return # No change, so we don't need to do anything

	star_hydrogen = next_hydrogen

	# Test if we have reached the threshold for this star-teir
	var target_threshold = StellarConstants.get_threshold( tier_state + 1 )
	if( star_hydrogen >= target_threshold ):
		# We have reached the threshold, so we need to increment the tier state
		tier_state = tier_state + 1
		# We also need to update the current shader props
		current_shader_props = StellarConstants.get_tier_state( tier_state )
		# And write the data to the shader

		EventBus.emit_signal( "star_transitioned" , tier_state )
		EventBus.emit_signal( "star_size_changed" , current_shader_props.interpolated_metadata )

		_shader_data_write( current_shader_props )
		return

	var percent_change = StellarConstants.get_tier_percent_diff( star_hydrogen , tier_state , tier_state + 1 )
	_apply_size_change( percent_change )


func _init_data_write( data : Dictionary ) -> void:
	# Metadata
	star_class = data.metadata.star_class
	description = data.metadata.description

func _shader_data_write( data : Dictionary ) -> void:

	# Interpolated Metadata
	temperature = data.interpolated_metadata.temperature
	luminosity = data.interpolated_metadata.luminosity
	mass = data.interpolated_metadata.mass
	set_scale( Vector2( data.interpolated_metadata.scale , data.interpolated_metadata.scale ) )

	# Corona and star body
	for prop in data.corona:
		corona_mat.set_shader_parameter( prop, data.corona[prop] )
	
	for prop in data.star_body:
		starbody_mat.set_shader_parameter( prop, data.star_body[prop] )

	for p_type in data.gradient:
		for idx in range( 0 , data.gradient[p_type].size() ):
			var val = data.gradient[p_type][idx]
			if( p_type == "colors" ):
				starbody_gradient.set_color( idx , Color( val.x , val.y , val.z ) )
			else:
				starbody_gradient.set_offset( idx , val )

	EventBus.emit_signal( "star_size_changed", data.interpolated_metadata )

# This method interpolates values on the basis of current and next tiers.
# these numbers are then used in a tween to apply a more fine grained interpolation designed to sync up with resource tics.
func _apply_size_change( percent_change : float ):
	if( tier_state == Constants.Tiers.TIER_3 ):
		return # Star is at the final state, so we don't need to apply size changes anymore.

	var current_tier_data = StellarConstants.get_tier_state( tier_state )
	var next_tier_data = StellarConstants.get_tier_state( tier_state + 1 )
	var target = StellarConstants.get_blank_tier_data()

	# Metadata properties
	for prop in current_tier_data.interpolated_metadata:
		var current_value = current_tier_data.interpolated_metadata[prop]
		var next_value = next_tier_data.interpolated_metadata[prop]

		var interpolated_value = current_value + ( ( next_value - current_value ) * percent_change )

		target.interpolated_metadata[prop] = interpolated_value

	# Star body interpolation
	for prop in current_tier_data.star_body:
		var current_value = current_tier_data.star_body[prop]
		var next_value = next_tier_data.star_body[prop]

		var interpolated_value = current_value + ( ( next_value - current_value ) * percent_change )

		target.star_body[prop] = interpolated_value
		
	# Handling the Corona
	for prop in current_tier_data.corona:
		var current_value = current_tier_data.corona[prop]
		var next_value = next_tier_data.corona[prop]

		var interpolated_value = current_value + ( ( next_value - current_value ) * percent_change )

		target.corona[prop] = interpolated_value

	# Handling gradients - structure is assumed to be dictionary -> array -> value
	for p_type in current_tier_data.gradient:
		target.gradient[p_type] = []
		
		for idx in range( 0 , current_tier_data.gradient[p_type].size() ):
			var current_value = current_tier_data.gradient[p_type][idx]
			var next_value = next_tier_data.gradient[p_type][idx]

			var interpolated_value = current_value + ( ( next_value - current_value ) * percent_change )

			target.gradient[p_type].append( interpolated_value )

	_shader_data_write( target )
