class_name PlanetResourceSlider
extends HBoxContainer


@export var resource_type: String = ""


@onready var resource_label = $Resource
@onready var slider = $HSlider
@onready var value_label = $Value


func _ready() -> void:
	resource_label.text = resource_type


func _on_slider_value_changed(value: float):
	value_label.text = str(value)

