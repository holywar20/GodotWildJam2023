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
	print(pos)
	set_position(pos)
	animPlayer.play("NOTIFICATION")
	await animPlayer.animation_finished
	queue_free()
