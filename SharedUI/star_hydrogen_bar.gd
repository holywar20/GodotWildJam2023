class_name StarHydrogenBar
extends PanelContainer


@onready var _total_hydrogen_bar = $VBoxContainer/TotalHydrogenProgressBar
@onready var _target_hydrogen_bar = $VBoxContainer/PanelContainer


func _ready() -> void:
	EventBus.star_hydrogen_updated.connect(_on_star_hydrogen_updated)
	EventBus.star_hydrogen_target_updated.connect(_on_star_hydrogen_target_updated)


func _on_star_hydrogen_updated(current_amount: int, target_amount: int) -> void:
	_total_hydrogen_bar.max_value = target_amount
	_total_hydrogen_bar.value = current_amount


func _on_star_hydrogen_target_updated(min_target: int, max_target: int) -> void:
	if not _target_hydrogen_bar.get_node("Sprite2D").visible:
		_target_hydrogen_bar.get_node("Sprite2D").show()

	_target_hydrogen_bar.get_node("Sprite2D").offset.x = _target_hydrogen_bar.size.x * (min_target / _total_hydrogen_bar.max_value)
