extends Node2D

# Should be less than the resource tick
const tween_duration : float = 4.0

var teir_state : int = 0
var nteir_progress : float = 0.0

var star_class : String = "Not assigned"
var description : String = "Not assigned"
var temerature : float = 0
var luminosity : float = 0
var mass : float = 0

var over_input_threshold : float = 0.0
var under_input_threshold : float = 0.0

var target_shader_values : Dictionary = {}

func _ready() -> void:
	pass

func _on_resources_reported( resources : Array ):
	pass

func _get_new_target_values() -> Dictionary:
	return {
		'corona' : {

		},
		'star' : {

		}
	}

func _apply_size_change( percent_change : float ):
	# Apply temp changes right away with lerp
	# Create a new set of target values
	# Then create a tween, loop over that tween and apply the new target values using a tween.
	pass
