extends Label

@onready var animPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func playWarning(planet):
	show()
	var warningText = "WARNING: " + planet.p_name + " is approaching Hydrogen depletion"
	set_text(warningText)
	animPlayer.play("WARNING")
	await animPlayer.animation_finished
	hide()
