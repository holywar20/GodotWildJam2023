extends PanelContainer


@onready var scale_label = $TimeScaleContainer/Panel/Numbers/Scale


func _ready() -> void:
	EventBus.time_scale_updated.connect(_on_time_scale_updated)


func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			GameTime.increase_time_scale()


func _on_time_scale_updated(scale) -> void:
	scale_label.text = str(scale).pad_decimals(1)
