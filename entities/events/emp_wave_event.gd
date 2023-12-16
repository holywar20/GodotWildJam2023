class_name EMPWaveEvent
extends AbstractEvent


const PERCENT_CHANCE_TO_DISABLE = 0.33


var _effect_applied: bool = false


func _init():
	super()
	type = "EMP Wave"
	effect_length_in_ticks = 10

	description = """A 'nearby' star has gone nova, releasing a burst of electromagnetic radiation 
	in the direction of your star at an incredible speed. Caught off-guard, you have no time 
	to shield or protect your structures and systems, leaving them exposed the pulse as it travels 
	through your star system.
	
	EFFECT: Random buildings are disabled for a period of time.
	"""


func apply_effect() -> void:
	if not _effect_applied:
		EventBus.emp_wave_happened.emit(PERCENT_CHANCE_TO_DISABLE)
		_effect_applied = true
