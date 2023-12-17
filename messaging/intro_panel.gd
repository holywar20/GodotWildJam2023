extends Panel


@onready var start_button = $Control3/StartButton


func _ready() -> void:
	# description.text = StellarConstants.get_tier_metadata(0).description
	pass

func _on_start_button_pressed():
	EventBus.new_game.emit()
	hide()
