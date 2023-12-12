extends Button

@onready var pName = $HBox/VBox/Planet

var planetRef = null
var planetLoc : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func updateUI(nPlanet):
	planetRef = nPlanet
	pName.set_text(planetRef.p_name)


func _on_pressed():
	pass # Replace with function body.
