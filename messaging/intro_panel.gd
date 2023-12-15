extends Panel


@onready var start_button = $Control3/StartButton
@onready var description = $Control2/Description


func _ready() -> void:
	description.text = StellarConstants.get_tier_metadata(0).description

func _on_start_button_pressed():
	EventBus.new_game.emit()
	hide()
