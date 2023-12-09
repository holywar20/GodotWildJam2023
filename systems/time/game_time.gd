extends Node


const WAIT_TIME = 5.0


@onready var timer = $Timer

var scale: float = 1.0


func _ready() -> void:
	timer.wait_time = WAIT_TIME
	timer.timeout.connect(_on_timer_timeout)


func _on_timer_timeout() -> void:
	EventBus.tick.emit()

