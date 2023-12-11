extends Node


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func _process(_delta):
	if Input.is_action_just_pressed("ui_pause"):
		get_tree().paused = not get_tree().paused
