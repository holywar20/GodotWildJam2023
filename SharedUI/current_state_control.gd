class_name CurrentStateControl
extends PanelContainer


const TEMPERATURE_KEY = "temperature"
const LUMINOSITY_KEY = "luminosity"
const MASS_KEY = "mass"


@onready var temperature_value = $VBoxContainer/TemperatureContainer/HBoxContainer/Value
@onready var luminosity_value = $VBoxContainer/LuminosityContainer/HBoxContainer/Value
@onready var mass_value = $VBoxContainer/MassContainer/HBoxContainer/Value


func _ready():
	EventBus.star_size_changed.connect(_on_star_size_changed)


func _on_star_size_changed(data) -> void:
	temperature_value.text = str(data[TEMPERATURE_KEY]).pad_decimals(1)
	luminosity_value.text = str(data[LUMINOSITY_KEY]).pad_decimals(4)
	mass_value.text = str(data[MASS_KEY]).pad_decimals(2)
