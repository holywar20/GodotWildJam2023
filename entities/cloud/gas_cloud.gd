class_name GasCloud
extends Control


@export var hydrogen_remaining: int = 25000

# per tick
@export var hydrogen_flow: int = 50

@onready var sprite = $Sprite2D

var _total_hydrogen: int


func _ready() -> void:
	EventBus.game_restart.connect(_on_game_restart)
	_total_hydrogen = hydrogen_remaining


func _on_game_restart() -> void:
	hydrogen_remaining = _total_hydrogen


# percentage: decimal between 0.0 and 1.0
func extract_hydrogen(percentage: float) -> int:
	var to_extract = int(hydrogen_flow * percentage)
	var extracted = to_extract

	if hydrogen_remaining - to_extract <= 0:
		extracted = hydrogen_remaining
		hydrogen_remaining = 0
		# hack: instead of having the cloud removed, we'll just hide it for now
		visible = false
	else:
		hydrogen_remaining -= to_extract

	_dissipate(float(hydrogen_remaining) / float(_total_hydrogen))

	return extracted


func has_hydrogen_remaining() -> bool:
	return hydrogen_remaining > 0


func _dissipate(percentage_left: float) -> void:
	sprite.material.set("shader_parameter/alpha", percentage_left)


func _on_mouse_entered():
	EventBus.gas_cloud_hovering.emit(self)


func _on_mouse_exited():
	EventBus.gas_cloud_stop_hovering.emit(self)
