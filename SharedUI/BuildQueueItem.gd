extends PanelContainer

@onready var buildingName = $VBox/Label
@onready var progressBar = $VBox/ProgressBar

# The actual building object
var building


func setName(nName):
	buildingName.set_text(str(nName))


func updateUI(rawPercent):
	var accPercent = rawPercent*100
	progressBar.set_value(accPercent)


func _on_progress_bar_value_changed(value):
	if value == 100:
		pass
