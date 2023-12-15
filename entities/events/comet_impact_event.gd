class_name CometImpactEvent
extends AbstractEvent


var hydrogen_amount_per_tick: int = 100


func _init():
	super()
	type = "Comet Impact"
	effect_length_in_ticks = 20

	description = """A large but typically benign comet in the solar system has had its orbit 
	destabilized by the gravitational pull of nearby planets! The comet's trajectory decays 
	and is altered sufficiently to send it directly into the star, even as the comet is torn 
	apart and its massive fragments begin streaming into the giant ball of gas...
	
	EFFECT: Hydrogen flow into the star is greatly increased for a period of time.
	"""


func apply_effect() -> void:
	EventBus.adjust_hydrogen.emit(hydrogen_amount_per_tick)
