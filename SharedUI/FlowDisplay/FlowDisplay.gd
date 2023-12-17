extends Panel

const LABEL_X_OFFSET = 30 # Offset to account for controls 0.0 in the upper right-hand corner.
const IDEAL_VERT_OFFSET = 50 # Y offset for placing the ideal value
const TWEEN_LENGTH = 0.95 # Length of animation in seconds. Meant to be slightly shorter than a tweak.

const IDEAL_SIZE = 125
const FLOW_WIDGET_SIZE = 500

@onready var toLittleLabel : Label = $HBox/ToLittle/ToLittleLabel
@onready var flowLabel : Label = $FlowLabel
@onready var toMuchLabel : Label = $HBox/ToMuch/ToMuchLabel
@onready var idealLabel : Label = $HBox/JustRight/IdealLabel

@onready var toLittle: Panel = $HBox/ToLittle
@onready var justRight : Panel = $HBox/JustRight
@onready var toMuch : Panel = $HBox/ToMuch

var prev_hydro : int = 0
var current_ideal : int = 0
var current_min_f : int = 0
var current_max_f : int = 0


var DANGER_TO_END_GAME : int = 5
var danger_count : int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("hydrogen_flow_updated" , Callable( self , "_on_hydrogen_flow_updated" ) )
	EventBus.connect("resources_reported" , Callable( self , "_on_resources_reported" ) )
	
	hide() # Hide flow control until you start getting Hydrogen

func _on_resources_reported( resources ) -> void:
	if( !is_visible() ): # Control is paused until you gain your first bit of Hydrogen
		return

	var this_hydro = resources[Constants.HYDROGEN]

	var flow = this_hydro - prev_hydro
	prev_hydro = this_hydro

	flowLabel.set_text( str( flow ) )

	idealLabel.set_text( str( current_ideal ) )
	toMuchLabel.set_text( str( current_min_f ) )
	toLittleLabel.set_text( str( current_max_f ) )
	
	var percentFlow : float = ( float(flow) - float(current_min_f) ) / ( float(current_max_f) - float(current_min_f) )
	# Right hand side should be at the center at 100%, and invisible when at 0%.
	# Left hand side should be at the center at 0% and invisible when at 100%.
	var leftHandSize = ( FLOW_WIDGET_SIZE * 0.5 ) * percentFlow
	var rightHandSize = ( FLOW_WIDGET_SIZE * 0.5 ) * ( 1.0 - percentFlow )
	var centerBarSize = FLOW_WIDGET_SIZE - ( rightHandSize + leftHandSize )

	leftHandSize = clamp( leftHandSize , 0 , FLOW_WIDGET_SIZE )
	rightHandSize = clamp( rightHandSize , 0 , FLOW_WIDGET_SIZE )

	var shiftTween = create_tween()
	shiftTween.parallel().tween_property( toLittle , 'custom_minimum_size' , Vector2( leftHandSize , 0 ) , TWEEN_LENGTH )
	shiftTween.parallel().tween_property( toMuch , 'custom_minimum_size', Vector2( rightHandSize , 0 ) , TWEEN_LENGTH )

	if( flow > current_max_f  || flow < current_min_f ):
		danger_count += 1

	EventBus.emit_signal( "danger_count" , danger_count )

	shiftTween.play()

func _on_hydrogen_flow_updated( _flow, ideal, min_f, max_f )-> void:
	show()

	current_ideal = ideal
	current_min_f = min_f
	current_max_f = max_f
