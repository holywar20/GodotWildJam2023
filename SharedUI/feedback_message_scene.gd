extends HBoxContainer

@onready var messageBox = $Control
@onready var animPlayer = $AnimationPlayer

func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func beginMessage(nText, pos):
	messageBox.text = nText
	#print(pos)
	set_position(pos)
	var tween = create_tween()
	tween.tween_property(self, "position", position - Vector2(0, 100), 0.75)
	tween.tween_callback(queue_free)
