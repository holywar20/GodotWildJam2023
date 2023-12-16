class_name AntimatterFactory
extends AbstractBuilding


func _on_button_pressed():
	EventBus.emit_signal("building_pressed", self)
