extends Panel


@onready var return_button = $Control3/ReturnButton


func _ready() -> void:
	EventBus.show_credits.connect(_on_show_credits)


func _on_return_button_pressed():
	hide()
	EventBus.show_intro.emit()


func _on_show_credits() -> void:
	show()
