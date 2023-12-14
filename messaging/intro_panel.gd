extends Panel


@onready var start_button = $Control3/StartButton


func _on_start_button_pressed():
	EventBus.new_game.emit()
	hide()
