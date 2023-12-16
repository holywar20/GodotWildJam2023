class_name Gigafactory
extends AbstractBuilding


@export var build_speedup_factor: float = 2.0


func _on_button_pressed():
	EventBus.emit_signal("building_pressed", self)
