class_name DysonSwarm
extends AbstractBuilding

# Overrides!
func _set_nodes() -> void:
	pass # Dyson swarm does not need sprites. TODO : Set up particle effects here.


func _on_button_pressed():
	EventBus.emit_signal("building_pressed", self)
