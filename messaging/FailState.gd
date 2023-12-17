extends Panel

@onready var description = $Control/Description

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("danger_fail", Callable(self, "_on_EB_danger_fail"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_EB_danger_fail(dir):
	show()
	match dir:
		"high":
			description.text = "Too much hydrogen flowing into the star caused it to go supernova!"
		"low":
			description.text = "Too little hydrogen flowing into the star caused it to collapse!"

	EventBus.game_paused.emit(false)

func _on_button_pressed():
	EventBus.game_unpaused.emit()
	EventBus.emit_signal("game_restart")
	EventBus.return_to_star_pressed.emit()
	hide()


func _on_button_mouse_entered():
	AudioManager.play_sfx("HOVER_BUTTON")
