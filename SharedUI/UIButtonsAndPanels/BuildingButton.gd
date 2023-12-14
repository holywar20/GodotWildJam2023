extends Button

@export var buildingRef : String = ""

@onready var buildingName = $HBox/HBox/VBox/BuildingName
@onready var buildingIcon = $HBox/TextureRect

@onready var powerContainer = $HBox/HBox/VBox/HBoxContainer/Power
@onready var baseContainer = $HBox/HBox/VBox/HBoxContainer/Base
@onready var precContainer = $HBox/HBox/VBox/HBoxContainer/Prec
@onready var antimatterContainer = $HBox/HBox/VBox/HBoxContainer/Antimatter
@onready var opPowerContainer = $HBox/Operationals/Power
@onready var opBaseContainer = $HBox/Operationals/Base
@onready var opPrecContainer = $HBox/Operationals/Prec
@onready var opAntimatterContainer = $HBox/Operationals/Antimatter

@onready var powerLabel = $HBox/HBox/VBox/HBoxContainer/Power/PowerCost
@onready var baseLabel = $HBox/HBox/VBox/HBoxContainer/Base/BaseCost
@onready var precLabel = $HBox/HBox/VBox/HBoxContainer/Prec/PrecCost
@onready var antimatterLabel = $HBox/HBox/VBox/HBoxContainer/Antimatter/AntimatterCost

@onready var opPowerLabel = $HBox/Operationals/Power/Power
@onready var opBaseLabel = $HBox/Operationals/Base/Base
@onready var opPrecLabel = $HBox/Operationals/Prec/Prec
@onready var opAntimatterLabel = $HBox/Operationals/Antimatter/Antimatter

var icons = {
	"Gigafactory" : "res://Assets/Placeholder 50x50.png",
	"Fusion Reactor" : "res://Assets/Placeholder 50x50.png" ,
	"Celestial Extractor" : "res://Assets/Placeholder 50x50.png" ,
	"Dyson Swarm" : "res://Assets/Placeholder 50x50.png" ,
	"Magnetic Bore" : "res://Assets/Placeholder 50x50.png" ,
	"Antimatter Factory" : "res://Assets/Placeholder 50x50.png" ,
	"Stellar Accelerator" : "res://Assets/Placeholder 50x50.png" ,
	"Starlifter" : "res://Assets/Placeholder 50x50.png"
}

var buildingArray = Info.BUILDING_INFO
var building 
var buildCostDict

func _ready():
	
	match buildingRef:
		"Gigafactory":
			buildingName.set_text(buildingRef)
			building = buildingArray.filter(func (b): return b.type == Constants.BUILDING_GIGAFACTORY)[0]
		"Fusion Reactor":
			buildingName.set_text(buildingRef)
			building = buildingArray.filter(func (b): return b.type == Constants.BUILDING_FUSION_REACTOR)[0]
		"Celestial Extractor":
			buildingName.set_text(buildingRef)
			building = buildingArray.filter(func (b): return b.type == Constants.BUILDING_CELESTIAL_EXTRACTOR)[0]
		"Dyson Swarm":
			buildingName.set_text(buildingRef)
			building = buildingArray.filter(func (b): return b.type == Constants.BUILDING_DYSON_SWARM)[0]
		"Magnetic Bore":
			buildingName.set_text(buildingRef)
			building = buildingArray.filter(func (b): return b.type == Constants.BUILDING_MAGNETIC_BORE)[0]
		"Antimatter Factory":
			buildingName.set_text(buildingRef)
			building = buildingArray.filter(func (b): return b.type == Constants.BUILDING_ANTIMATTER_FACTORY)[0]
		"Stellar Accelerator":
			buildingName.set_text(buildingRef)
			building = buildingArray.filter(func (b): return b.type == Constants.BUILDING_STELLAR_ACCELERATOR)[0]
		"Starlifter":
			buildingName.set_text(buildingRef)
			building = buildingArray.filter(func (b): return b.type == Constants.BUILDING_STARLIFTER)[0]
	buildingIcon.set_texture(load(icons[buildingRef]))
	buildCostDict = building.building_costs
	setupStats(buildCostDict)

func setupStats(buildCostDict):
	var opCostDict = building.operational_costs
	var produceDict = building.produces
	if buildCostDict.has(Constants.POWER):
		powerContainer.show()
		powerLabel.text = str(buildCostDict[Constants.POWER])
	if buildCostDict.has(Constants.BASE_METAL):
		baseContainer.show()
		baseLabel.text = str(buildCostDict[Constants.BASE_METAL])
	if buildCostDict.has(Constants.PRECIOUS_METAL):
		precContainer.show()
		precLabel.text = str(buildCostDict[Constants.PRECIOUS_METAL])
	if buildCostDict.has(Constants.ANTIMATTER):
		antimatterContainer.show()
		antimatterLabel.text = str(buildCostDict[Constants.BASE_METAL])
	
	if opCostDict.has(Constants.POWER):
		opPowerContainer.show()
		opPowerLabel.text = str(opCostDict[Constants.POWER])
		opPowerLabel.modulate = (Color(1,0.1,0.1,1))
	if opCostDict.has(Constants.BASE_METAL):
		opBaseContainer.show()
		opBaseLabel.text = str(opCostDict[Constants.BASE_METAL])
		opBaseLabel.modulate = (Color(1,0.1,0.1,1))
	if opCostDict.has(Constants.PRECIOUS_METAL):
		opPrecContainer.show()
		opPrecLabel.text = str(opCostDict[Constants.PRECIOUS_METAL])
		opPrecLabel.modulate = (Color(1,0.1,0.1,1))
	if opCostDict.has(Constants.ANTIMATTER):
		opAntimatterContainer.show()
		opAntimatterLabel.text = str(opCostDict[Constants.ANTIMATTER])
		opAntimatterLabel.modulate = (Color(1,0.1,0.1,1))

	if produceDict.has(Constants.POWER):
		opPowerContainer.show()
		opPowerLabel.text = str(produceDict[Constants.POWER])
		opPowerLabel.modulate = (Color(0.1,1,0.1,1))
	if produceDict.has(Constants.BASE_METAL):
		opBaseContainer.show()
		opBaseLabel.text = str(produceDict[Constants.BASE_METAL])
		opBaseLabel.modulate = (Color(0.1,1,0.1,1))
	if produceDict.has(Constants.PRECIOUS_METAL):
		opPrecContainer.show()
		opPrecLabel.text = str(produceDict[Constants.PRECIOUS_METAL])
		opPrecLabel.modulate = (Color(0.1,1,0.1,1))
	if produceDict.has(Constants.ANTIMATTER):
		opAntimatterContainer.show()
		opAntimatterLabel.text = str(produceDict[Constants.ANTIMATTER])
		opAntimatterLabel.modulate = (Color(0.1,1,0.1,1))


func _on_pressed():
	print(buildCostDict)
	EventBus.emit_signal("construction_requested", buildingRef)
