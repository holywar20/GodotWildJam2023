extends PanelContainer

@onready var menuLabel = $VBox/MenuName


var isOpen = false

func _ready():
	pass


func openClose():
	var t = create_tween()
	if(isOpen):
		t.tween_property(self, "modulate", Color.TRANSPARENT, 0.25)
		await t.finished
		hide()
	else:
		modulate = Color.TRANSPARENT
		show()
		t.tween_property(self, "modulate", Color.WHITE, 0.25)
		await t.finished

	isOpen = !isOpen


func openCloseNoTransition():
	if(isOpen):
		hide()
	else:
		show()

	isOpen = !isOpen
