extends Panel

@onready var amount = $VBoxContainer/PanelContainer/Amount

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("gas_cloud_stop_hovering", Callable(self, "_on_EB_gas_cloud_stop_hovering"))

func setupScene(cloudRef, pos):
	amount.text = str(cloudRef.hydrogen_remaining)
	set_position(pos+Vector2(-50,-100))

func _on_EB_gas_cloud_stop_hovering(gas_cloud):
	print("Stop")
	queue_free()
