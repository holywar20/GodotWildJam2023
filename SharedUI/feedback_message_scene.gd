extends HBoxContainer

@onready var messageBox = $Control


func beginMessage(nText, pos):
	messageBox.text = nText
	#print(pos)
	set_position(pos)
	var tween = create_tween()
	tween.tween_property(self, "position", position - Vector2(0, 100), 0.75)
	tween.tween_callback(queue_free)
