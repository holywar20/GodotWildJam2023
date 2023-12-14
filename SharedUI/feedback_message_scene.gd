extends HBoxContainer

@onready var messageBox = $Control


func beginMessage(nText, pos):
	messageBox.text = nText
	set_position(pos)

	# Have the text "rise"
	var tween = create_tween()
	tween.tween_property(self, "position", position - Vector2(0, 100), 1.0)
	tween.tween_callback(queue_free)

	# Have the text fade out
	create_tween().tween_property(self, "modulate", Color.TRANSPARENT, 1.0)
