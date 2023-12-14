class_name StellarAccelerator
extends AbstractBuilding


func _on_button_pressed():
	EventBus.emit_signal("building_pressed", Constants.BUILDING_STELLAR_ACCELERATOR)
