extends PanelContainer

@onready var navButtonContainer = $ScrollContainer/NavContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func updateUI():
	var planetArray = get_tree().get_nodes_in_group( "PLANET_SCENE" )
	for planet in planetArray:
		for panel in navButtonContainer.get_children():
			if panel.planetRef == null:
				panel.updateUI(planet)
				break
			if !(panel.planetRef == null):
				continue
