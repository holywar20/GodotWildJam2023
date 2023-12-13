extends Button

@export var buildingRef : String = ""

@onready var buildingName = $HBox/BuildingName

var buildingArray = Info.BUILDING_INFO
var building 

func _ready():
	building = buildingArray.filter(func (b): return b.type == Constants.BUILDING_GIGAFACTORY)[0]
	match buildingRef:
		"Gigafactory":
			buildingName.set_text(buildingRef)
			#for info in buildingArray:
				#if info.type == Constants.BUILDING_GIGAFACTORY:
					#building = info
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
	print(building)
	EventBus.emit_signal("construction_requested", buildingRef)
