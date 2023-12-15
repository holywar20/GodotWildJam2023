class_name CoronalMassEjectionEvent
extends AbstractEvent


var hydrogen_amount_per_tick: int = -100


func _init():
	super()
	type = "Coronal Mass Ejection"
	effect_length_in_ticks = 30

	description = """Stars are unpredictable at the best of times, even with the most advanced 
	prediction models. Just when you thought you understood the sunspot cycle, sudden 
	activity on the surface of the star produces an ultra-intense burst of radiation: 
	A coronal mass ejection, and it's as big as they come, each tendril sending enormous 
	amounts of hydrogen out into the vacuum of space at incredible speeds.
	
	EFFECT: The star loses a large amount of hydrogen to the cosmos for a period of time.
	"""


func apply_effect() -> void:
	EventBus.adjust_hydrogen.emit(hydrogen_amount_per_tick)
