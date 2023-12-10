extends PanelContainer

@onready var container = $ScrollContainer/VBoxContainer

var isOpen = false

func _ready():
	pass # Replace with function body.

func openClose():
	if(isOpen):
		hide()
	else:
		show()
	isOpen = !isOpen
