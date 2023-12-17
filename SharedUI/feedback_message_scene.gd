extends HBoxContainer

@onready var messageBox = $Control


func beginMessage(nText, pos):
	showMessage(nText, pos)

	# Have the text "rise"
	var tween = create_tween()
	tween.tween_property(self, "position", position - Vector2(0, 100), 1.0)
	tween.tween_callback(queue_free)

	# Have the text fade out
	create_tween().tween_property(self, "modulate", Color.TRANSPARENT, 1.0)


func showMessage(text, pos) -> void:
	messageBox.text = text
	set_position(pos)


func hideMessage() -> void:
	hide()
