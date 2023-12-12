extends Button

@onready var pName = $HBox/Planet

var planetRef = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func updateUI(nPlanet):
	planetRef = nPlanet
	print(nPlanet)
	pName.set_text(planetRef.p_name)


func _on_pressed():
	EventBus.planet_nav_button_pressed.emit(planetRef)
