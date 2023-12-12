class_name StarHydrogenBar
extends PanelContainer


@onready var _texture_bar = $VBoxContainer/TextureProgressBar


func _ready() -> void:
	EventBus.star_hydrogen_updated.connect(_on_star_hydrogen_updated)


func _on_star_hydrogen_updated(current_amount: int, target_amount: int) -> void:
	_texture_bar.max_value = target_amount
	_texture_bar.value = current_amount
