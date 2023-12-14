class_name StageCompletePanel
extends Panel


func _ready() -> void:
	EventBus.star_transitioned.connect(_on_star_transitioned)



func _gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			hide()
			EventBus.game_unpaused.emit()
			get_viewport().set_input_as_handled()


func _on_star_transitioned(_tier) -> void:
	EventBus.game_paused.emit(false)
	show()
