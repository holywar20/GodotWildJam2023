extends Panel


@onready var start_button = $Control3/StartButton


func _ready() -> void:
	EventBus.show_intro.connect(_on_show_intro)


func _on_start_button_pressed():
	EventBus.new_game.emit()
	hide()


func _on_show_intro() -> void:
	show()


func _on_credits_button_pressed():
	hide()
	EventBus.show_credits.emit()
