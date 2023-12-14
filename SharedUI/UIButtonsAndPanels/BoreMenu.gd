extends PanelContainer

@onready var menuLabel = $VBox/MenuName


var isOpen = false

func _ready():
	pass

func openClose():
	if(isOpen):
		hide()
	else:
		show()
	isOpen = !isOpen
