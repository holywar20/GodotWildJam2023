extends PanelContainer

@onready var buildingName = $VBox/Label
@onready var progressBar = $VBox/ProgressBar

func _ready():
	pass # Replace with function body.

func setName(nName):
	buildingName.set_text(str(nName))

func updateUI(rawPercent):
	var accPercent = rawPercent*100
	progressBar.set_show_percentage(accPercent)


func _on_progress_bar_value_changed(value):
	if value == 100:
		pass
