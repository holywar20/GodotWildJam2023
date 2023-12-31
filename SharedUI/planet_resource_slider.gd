class_name PlanetResourceSlider
extends VBoxContainer


@export var resource_type: String = ""


@onready var resource_label = $Resource
@onready var slider = $PlanetResourceSlider/HSlider
@onready var value_label = $PlanetResourceSlider/Value


func _ready() -> void:
	resource_label.text = resource_type


func _on_slider_value_changed(value: float) -> void:
	value_label.text = str(value * 100) + "%"


func set_init_value(value: float) -> void:
	slider.value = value
