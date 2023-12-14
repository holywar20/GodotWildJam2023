class_name FusionReactor
extends AbstractBuilding



func _on_button_pressed():
	EventBus.emit_signal("building_pressed", Constants.BUILDING_FUSION_REACTOR)
