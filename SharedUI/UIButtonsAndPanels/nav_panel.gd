extends PanelContainer


const PLANET_TIER_GROUPS = {
	1: "TIER_1_PLANETS",
	2: "TIER_2_PLANETS",
	3: "TIER_3_PLANETS"
}


@onready var navButtonContainer = $VBox/NavContainer


func _ready():
	EventBus.star_transitioned.connect(_on_star_transitioned)

	for planet_button in get_tree().get_nodes_in_group("TIER_1_PLANETS"):
		planet_button.visible = true


func updateUI():
	var planetArray = get_tree().get_nodes_in_group( "PLANET_SCENE" )
	for planet in planetArray:
		for panel in navButtonContainer.get_children():
			if panel.planetRef == null:
				panel.updateUI(planet)
				break
			if !(panel.planetRef == null):
				continue


func _on_star_pressed():
	EventBus.emit_signal("return_to_star_pressed")


func _on_star_transitioned(tier) -> void:
	if not PLANET_TIER_GROUPS.has(tier + 1):
		return

	for planet_button in get_tree().get_nodes_in_group(PLANET_TIER_GROUPS[tier + 1]):
		planet_button.visible = true
