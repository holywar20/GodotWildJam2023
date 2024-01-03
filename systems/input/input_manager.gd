extends Node


var _can_use_debug_console: bool = false
var _debug_console_visible: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	EventBus.game_paused.connect(_on_game_paused)
	EventBus.game_unpaused.connect(_on_game_unpaused)
	EventBus.new_game.connect(_on_new_game)
	EventBus.show_debug_console.connect(_on_show_debug_console)


func _process(_delta):
	if not _debug_console_visible and Input.is_action_just_pressed("ui_pause"):
		_handle_pause(true)
		return

	if _can_use_debug_console and Input.is_action_just_pressed("ui_show_console"):
		_handle_pause(false)
		EventBus.show_debug_console.emit()


func _handle_pause(show_pause_screen: bool) -> void:
	var is_paused = get_tree().paused

	if is_paused:
		EventBus.game_unpaused.emit()
	else:
		EventBus.game_paused.emit(show_pause_screen)


func _on_game_paused(_show_pause_screen) -> void:
	get_tree().paused = true


func _on_game_unpaused() -> void:
	get_tree().paused = false


func _on_new_game() -> void:
	_can_use_debug_console = true


func _on_show_debug_console() -> void:
	_debug_console_visible = not _debug_console_visible
