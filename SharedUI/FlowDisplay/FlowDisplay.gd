extends Panel

const LABEL_X_OFFSET = 30 # Offset to account for controls 0.0 in the upper right-hand corner.
const IDEAL_VERT_OFFSET = 50 # Y offset for placing the ideal value
const TWEEN_LENGTH = 0.95 # Length of animation in seconds. Meant to be slightly shorter than a tweak.

const IDEAL_SIZE = 125
const FLOW_WIDGET_SIZE = 500

@onready var toLittleLabel : Label = $ToLittleLabel
@onready var flowLabel : Label = $FlowLabel
@onready var toMuchLabel : Label = $ToMuchLabel
@onready var idealLabel : Label = $IdealLabel

@onready var toLittle: ColorRect = $HBox/ToLittle
@onready var justRight : ColorRect = $HBox/JustRight
@onready var toMuch : ColorRect = $HBox/ToMuch

var prev_flow : int = 0
var prev_ideal : int = 0
var prev_much : int = 0
var prev_little : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("hydrogen_flow_updated" , Callable( self , "_on_hydrogen_flow_updated" ) )

func _on_hydrogen_flow_updated( flow, ideal, min_f, max_f )-> void:
	flowLabel.set_text( str( flow ) )
	idealLabel.set_text( str( ideal ) )
	toMuchLabel.set_text( str( max_f ) )
	toLittleLabel.set_text( str( min_f ) )
	

	var percentFlow : float = ( float(flow) - float(min_f) ) / ( float(max_f) - float(min_f) )
	# Right hand side should be at the center at 100%, and invisible when at 0%.
	# Left hand side should be at the center at 0% and invisible when at 100%.
	var rightHandSize = ( FLOW_WIDGET_SIZE * 0.5 ) * percentFlow
	var leftHandSize = ( FLOW_WIDGET_SIZE * 0.5 ) * ( 1.0 - percentFlow )
	var centerBarSize = FLOW_WIDGET_SIZE - ( rightHandSize + leftHandSize )
	
	var shiftTween = create_tween()
	shiftTween.parallel().tween_property( toLittle , 'custom_minimum_size' , Vector2( leftHandSize , 0 ) , TWEEN_LENGTH )
	shiftTween.parallel().tween_property( toMuch , 'custom_minimum_size', Vector2( rightHandSize , 0 ) , TWEEN_LENGTH )
	
	# var currentIdealPos = idealLabel.get_position()
	# var centerBarPos = justRight.get_position()
	# var newIdealPos = centerBarPos + ( Vector2( centerBarSize.x * 0.5 , centerBarPos.y - 50 ) )
	
	# shiftTween.parellel().tween_property( idealLabel , 'position' , newIdealPos , 0.95 )
	shiftTween.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
