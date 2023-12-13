extends Button

@export var buildingRef : String = ""

@onready var buildingName = $HBox/BuildingName

var building
var buildingArray = Info.BUILDING_INFO

func _ready():
	match buildingRef:
		"Gigafactory":
			buildingName.set_text(buildingRef)
		"Fusion Reactor":
			buildingName.set_text(buildingRef)
		"Celestial Extractor":
			buildingName.set_text(buildingRef)
		"Dyson Swarm":
			buildingName.set_text(buildingRef)
		"Magnetic Bore":
			buildingName.set_text(buildingRef)
		"Antimatter Factory":
			buildingName.set_text(buildingRef)
		"Stellar Accelerator":
			buildingName.set_text(buildingRef)
		"Starlifter":
			buildingName.set_text(buildingRef)


func _on_pressed():
	EventBus.emit_signal("construction_requested", buildingRef)
