extends Panel

@onready var toLittleLabel : Label = $ToLittleLabel
@onready var flowLabel : Label = $FlowLabel
@onready var toMuchLabel : Label = $ToMuchLabel
@onready var idealLabel : Label = $IdealLabel

@onready var toLittleRect : ColorRect = $HBox/ToLittle
@onready var justRight : ColorRect = $HBox/JustRight
@onready var toMuch : ColorRect = $HBox/ToMuch

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("hydrogen_flow_updated" , Callable( self , "_on_hydrogen_flow_updated" ) )

func _on_hydrogen_flow_updated( flow, ideal, min_f, max_f )-> void:
	flowLabel.set_text( str( flow ) )
	idealLabel.set_text( str( ideal ) )
	toMuchLabel.set_text( str( max_f ) )
	toLittleLabel.set_text( str( min_f ) )

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
