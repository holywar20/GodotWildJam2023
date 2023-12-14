class_name Messaging
extends CanvasLayer


@onready var pause_panel = $PausePanel


func _ready() -> void:
	EventBus.game_paused.connect(_on_game_paused)
	EventBus.game_unpaused.connect(_on_game_unpaused)


func _on_game_paused(show_pause_screen) -> void:
	if show_pause_screen:
		pause_panel.show()


func _on_game_unpaused() -> void:
	pause_panel.hide()
