class_name CoronalMassEjectionEvent
extends AbstractEvent


@export var hydrogen_amount_per_tick: int = -100


func apply_effect() -> void:
	EventBus.adjust_hydrogen.emit(hydrogen_amount_per_tick)
