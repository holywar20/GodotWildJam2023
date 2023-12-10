class_name AbstractEvent
extends Object


@export var effect_length_in_ticks: float = 1.0

var _tick_count: int = 0
var _is_finished: bool = false:
	get = is_finished


func _init() -> void:
	EventBus.tick.connect(_on_tick)


func _on_tick() -> void:
	if _tick_count >= effect_length_in_ticks:
		_is_finished = true
		return

	apply_effect()

	_tick_count += 1


func is_finished() -> bool:
	return _is_finished


func apply_effect() -> void:
	pass
