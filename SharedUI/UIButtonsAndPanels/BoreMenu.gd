extends PanelContainer

@onready var menuLabel = $VBox/MenuName
@onready var slider = $VBox/Hbox/SliderCont/Slider
@onready var percentLabel = $VBox/Hbox/PercentCont/Percent

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


func _on_slider_value_changed(value):
	percentLabel.set_text("% " + str(value))
