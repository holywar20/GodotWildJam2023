extends Node


const WAIT_TIME = 1.0 # The time between emitting the `tick` signal
const SCALE_SETTINGS = [1.0, 2.0, 4.0, 16.0]

@onready var timer = $Timer

var scale: float = 1.0

var _current_scale_index = 0


func _ready() -> void:
	timer.wait_time = WAIT_TIME
	timer.timeout.connect(_on_timer_timeout)
	EventBus.game_restart.connect(_on_game_restart)


func _on_timer_timeout() -> void:
	EventBus.tick.emit()


func increase_time_scale() -> void:
	_current_scale_index = (_current_scale_index + 1) % SCALE_SETTINGS.size()
	scale = SCALE_SETTINGS[_current_scale_index]
	timer.wait_time = WAIT_TIME / scale
	EventBus.time_scale_updated.emit(scale)


func _on_game_restart() -> void:
	_current_scale_index = 0
	scale = SCALE_SETTINGS[_current_scale_index]
	timer.wait_time = WAIT_TIME / scale
	EventBus.time_scale_updated.emit(scale)
