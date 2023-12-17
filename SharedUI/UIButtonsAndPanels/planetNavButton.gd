extends Button

@onready var pName = $HBox/Planet
@onready var pIcon = $HBox/PlanetIcon/Planet

var planetRef = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func updateUI(nPlanet):
	planetRef = nPlanet
	pName.set_text(planetRef.p_name)
	
	var pid = planetRef.pid
	
	pIcon.set_as_icon( planetRef.pid )


func _on_pressed():
	EventBus.planet_nav_button_pressed.emit(planetRef)


func _on_mouse_entered():
	AudioManager.play_sfx("HOVER_BUTTON")
