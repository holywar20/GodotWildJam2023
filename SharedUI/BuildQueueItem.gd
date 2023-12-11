extends PanelContainer

@onready var buildingName = $VBox/Label
@onready var progressBar = $VBox/ProgressBar
@onready var buildComplete = $VBox/BuildComplete
@onready var animationPlayer = $AnimationPlayer

# The actual building object
var building


func _ready() -> void:
	EventBus.tick.connect(_on_tick)


func setName(nName):
	buildingName.set_text(str(nName))


func _on_tick() -> void:
	updateUI()


func updateUI():
	if not building:
		return

	var accPercent = building.get_construction_complete_percentage() * 100
	progressBar.set_value(accPercent)


func removeSelf():
	EventBus.tick.disconnect(_on_tick)
	var vanishTween = create_tween()
	progressBar.hide()
	buildComplete.show()
	animationPlayer.play("BUILDING_FINISHED")
	vanishTween.tween_property(buildingName.owner, 'position', Vector2(300,0), 1)
	await animationPlayer.animation_finished
	queue_free()

