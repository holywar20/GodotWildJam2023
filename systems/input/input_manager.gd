extends Node


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func _process(_delta):
	if Input.is_action_just_pressed("ui_pause"):
		_do_pause()


func _do_pause():
	get_tree().paused = not get_tree().paused

	if get_tree().paused:
		EventBus.game_paused.emit()
	else:
		EventBus.game_unpaused.emit()

