class_name StageCompletePanel
extends Panel


const DEFAULT_MESSAGE = "The star has grown. Keep it going without losing control..."


@onready var description = $Control/Description


func _ready() -> void:
	EventBus.star_transitioned.connect(_on_star_transitioned)


func _gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			hide()
			EventBus.game_unpaused.emit()
			get_viewport().set_input_as_handled()


func _on_star_transitioned(tier) -> void:
	var star_metadata: Dictionary = StellarConstants.get_tier_metadata(tier)

	description.text = StellarConstants.get_tier_metadata(tier).description if star_metadata.has("description") else DEFAULT_MESSAGE

	EventBus.game_paused.emit(false)
	show()
