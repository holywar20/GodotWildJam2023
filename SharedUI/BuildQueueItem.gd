extends PanelContainer

@onready var buildingName = $VBox/Label
@onready var progressBar = $VBox/ProgressBar
@onready var buildComplete = $VBox/BuildComplete
@onready var animationPlayer = $AnimationPlayer

# The actual building object
var building


func setName(nName):
	buildingName.set_text(str(nName))


func updateUI(rawPercent):
	var accPercent = rawPercent*100
	progressBar.set_value(accPercent)

func removeSelf():
	var vanishTween = create_tween()
	progressBar.hide()
	buildComplete.show()
	animationPlayer.play("BUILDING_FINISHED")
	vanishTween.tween_property(buildingName.owner, 'position', Vector2(300,0), 1)
	await animationPlayer.animation_finished
	queue_free()

