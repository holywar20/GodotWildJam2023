class_name EventPanel
extends Panel


@onready var _description = $Control/Description


func _ready() -> void:
	EventBus.event_started.connect(_on_event_started)


func _gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			hide()
			EventBus.game_unpaused.emit()
			get_viewport().set_input_as_handled()


func _on_event_started(event) -> void:
	_description.text = event.description
	EventBus.game_paused.emit(false)
	show()
