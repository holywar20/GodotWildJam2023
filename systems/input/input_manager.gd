extends Node


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	EventBus.game_paused.connect(_on_game_paused)
	EventBus.game_unpaused.connect(_on_game_unpaused)


func _process(_delta):
	if Input.is_action_just_pressed("ui_pause"):
		var is_paused = get_tree().paused

		if is_paused:
			EventBus.game_unpaused.emit()
		else:
			EventBus.game_paused.emit(true)
		return


func _on_game_paused(_show_pause_screen) -> void:
	get_tree().paused = true


func _on_game_unpaused() -> void:
	get_tree().paused = false
