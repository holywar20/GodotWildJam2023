extends Node


const EVENTS = [
	preload("res://entities/events/coronal_mass_ejection_event.gd")
]

var _event_chance: float = 0.001:
	set = set_event_chance

var _current_events: Array = []


func _ready():
	EventBus.tick.connect(_on_tick)


func set_event_chance(value: float) -> void:
	_event_chance = value


func _on_tick() -> void:
	if randf() < _event_chance and _current_events.size() == 0:
		_generate_event()
		return

	_process_finished_events()


func _generate_event() -> void:
	_current_events.append(EVENTS[randi_range(0, EVENTS.size() - 1)])


func _process_finished_events() -> void:
	var events_to_erase: Array = _current_events.filter(func(event): return event.is_finshed())

	for event in events_to_erase:
		_current_events.erase(event)
