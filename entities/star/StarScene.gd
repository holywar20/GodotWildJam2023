extends Node2D

# Should be less than the resource tick
const tween_duration : float = 4.0

var tier_state = Constants.Tiers.TIER_0
var nteir_progress : float = 0.0

var star_class : String = "Not assigned"
var description : String = "Not assigned"
var temerature : float = 0
var luminosity : float = 0
var mass : float = 0

var over_input_threshold : float = 0.0
var under_input_threshold : float = 0.0

# Materials
var corona_mat : ShaderMaterial
var starbody_mat : ShaderMaterial

var target_shader_values : Dictionary = {}

func _ready() -> void:
	var starState = StellarConstants.get_tier_state( tier_state )

	corona_mat = $Corona.get_material()
	starbody_mat = $StarBody.get_material()

	_write_corona_params( starState.corona )
	_write_star_params( starState.star )
	_write_metadata_props( starState.metadata )

func _on_resources_reported( resources : Array ):
	pass

func _get_new_target_values() -> Dictionary:
	return {
		'corona' : {

		},
		'star' : {

		}
	}

# Need to build a new gradient for interpolation purposes.
func _write_metadata_props( metadata : Dictionary ) -> void:
	pass

	# Broadcast signal

func _write_corona_params( params : Dictionary ) -> void:
	for prop in params:
		corona_mat.set_shader_parameter( prop, params[prop] )

func _write_star_params( params : Dictionary ) -> void:
	for prop in params:
		starbody_mat.set_shader_parameter( prop, params[prop] )

func _apply_size_change( percent_change : float ):
	if( tier_state == Constants.Tiers.TIER_3 ):
		return # Star is at the final state, so we don't need to apply size changes anymore.

	var current_tier_data = StellarConstants.get_tier_state( tier_state )
	var next_tier_data = StellarConstants.get_tier_state( tier_state + 1 )
	var tween_data = StellarConstants.get_blank_tier_data()

	


	# Perform metadata interpolations
	# Broadcast star changes for UI

	# Apply temp changes right away with lerp
	# Create a new set of target values
	# Then create a tween, loop over that tween and apply the new target values using a tween.
	pass
