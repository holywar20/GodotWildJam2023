extends PanelContainer

@onready var buildingName = $VBox/Label
@onready var progressBar = $VBox/HBoxContainer/ProgressBar
@onready var buildComplete = $VBox/BuildComplete
@onready var animationPlayer = $AnimationPlayer
@onready var timerLabel = $Label
@onready var timer = $Timer

# The actual building object
var building


func _ready() -> void:
	EventBus.tick.connect(_on_tick)


func setName(nName):
	buildingName.set_text(str(nName))
	timer.wait_time = building.build_time
	timer.start()
	timerLabel.set_text(str(round(timer.time_left)) + " s")
	


func _on_tick() -> void:
	updateUI()


func updateUI():
	if not building:
		return

	var accPercent = building.get_construction_complete_percentage() * 100
	progressBar.set_value(accPercent)
	timerLabel.set_text(str(round(timer.time_left)) + " s")

func removeSelf():
	EventBus.tick.disconnect(_on_tick)
	var vanishTween = create_tween()
	progressBar.hide()
	timerLabel.hide()
	buildComplete.show()
	animationPlayer.play("BUILDING_FINISHED")
	vanishTween.tween_property(buildingName.owner, 'position', Vector2(300,self.position.y), 1)
	await animationPlayer.animation_finished
	queue_free()

