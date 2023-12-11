extends PanelContainer

@onready var buildingName = $VBox/Label
@onready var progressBar = $VBox/ProgressBar

func _ready():
	pass # Replace with function body.


func updateUI(rawPercent):
	var accPercent = rawPercent*100
	progressBar.set_show_percentage(accPercent)
