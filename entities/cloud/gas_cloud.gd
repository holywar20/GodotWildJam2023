class_name GasCloud
extends Node2D


@export var hydrogen_remaining: int = 25000

# per tick
@export var hydrogen_flow: int = 50

@onready var sprite = $Sprite2D

var _total_hydrogen: int


func _ready() -> void:
	_total_hydrogen = hydrogen_remaining


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
