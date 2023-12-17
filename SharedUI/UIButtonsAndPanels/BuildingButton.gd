extends Button

@export var buildingRef : String = ""

@onready var buildingName = $HBox/HBox/VBox/BuildingName
@onready var buildingIcon = $HBox/Panel/TextureRect

# Build Costs
@onready var powerContainer = $HBox/HBox/VBox/Build/Power
@onready var baseContainer = $HBox/HBox/VBox/Build/Base
@onready var precContainer = $HBox/HBox/VBox/Build/Prec
@onready var antimatterContainer = $HBox/HBox/VBox/Build/Antimatter

@onready var powerLabel = $HBox/HBox/VBox/Build/Power/PowerCost
@onready var baseLabel = $HBox/HBox/VBox/Build/Base/BaseCost
@onready var precLabel = $HBox/HBox/VBox/Build/Prec/PrecCost
@onready var antimatterLabel = $HBox/HBox/VBox/Build/Antimatter/AntimatterCost

# Operational Costs
@onready var opHydroContainer = $HBox/HBox/VBox/Operationals/Hydro
@onready var opPowerContainer = $HBox/HBox/VBox/Operationals/Power
@onready var opBaseContainer = $HBox/HBox/VBox/Operationals/Base
@onready var opPrecContainer = $HBox/HBox/VBox/Operationals/Prec
@onready var opAntimatterContainer = $HBox/HBox/VBox/Operationals/Antimatter

@onready var opHydroLabel = $HBox/HBox/VBox/Operationals/Hydro/Hydro
@onready var opPowerLabel = $HBox/HBox/VBox/Operationals/Power/Power
@onready var opBaseLabel = $HBox/HBox/VBox/Operationals/Base/Base
@onready var opPrecLabel = $HBox/HBox/VBox/Operationals/Prec/Prec
@onready var opAntimatterLabel = $HBox/HBox/VBox/Operationals/Antimatter/Antimatter

@onready var timeContainer = $HBox/HBox/VBox/Operationals/Time
@onready var timeLabel = $HBox/HBox/VBox/Operationals/Time/Time

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
	buildingIcon.set_texture(load(Constants.ICONS[buildingRef]))
	buildCostDict = building.building_costs
	setupStats(buildCostDict)

func setupStats(buildDict):
	var opCostDict = building.operational_costs
	var produceDict = building.produces
	if buildDict.has(Constants.POWER):
		powerContainer.show()
		powerLabel.text = str(buildDict[Constants.POWER])
	if buildDict.has(Constants.BASE_METAL):
		baseContainer.show()
		baseLabel.text = str(buildDict[Constants.BASE_METAL])
	if buildDict.has(Constants.PRECIOUS_METAL):
		precContainer.show()
		precLabel.text = str(buildDict[Constants.PRECIOUS_METAL])
	if buildDict.has(Constants.ANTIMATTER):
		antimatterContainer.show()
		antimatterLabel.text = str(buildDict[Constants.BASE_METAL])
	
	if opCostDict.has(Constants.HYDROGEN):
		opHydroContainer.show()
		opHydroLabel.text = "-" +  str(opCostDict[Constants.HYDROGEN])
		opHydroLabel.modulate = (Color(1,0.1,0.1,1))
	if opCostDict.has(Constants.POWER):
		opPowerContainer.show()
		opPowerLabel.text = "-" +  str(opCostDict[Constants.POWER])
		opPowerLabel.modulate = (Color(1,0.1,0.1,1))
	if opCostDict.has(Constants.BASE_METAL):
		opBaseContainer.show()
		opBaseLabel.text = "-" + str(opCostDict[Constants.BASE_METAL])
		opBaseLabel.modulate = (Color(1,0.1,0.1,1))
	if opCostDict.has(Constants.PRECIOUS_METAL):
		opPrecContainer.show()
		opPrecLabel.text = "-" +  str(opCostDict[Constants.PRECIOUS_METAL])
		opPrecLabel.modulate = (Color(1,0.1,0.1,1))
	if opCostDict.has(Constants.ANTIMATTER):
		opAntimatterContainer.show()
		opAntimatterLabel.text = "-" + str(opCostDict[Constants.ANTIMATTER])
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
	
	if building.type == Constants.BUILDING_GIGAFACTORY:
		timeContainer.show()
		timeLabel.text = str(snapped(building.build_speedup_factor, 1)) + " x"
		timeLabel.modulate = (Color(0.1,1,0.1,1))

func _on_pressed():
	EventBus.emit_signal("construction_requested", buildingRef)


func _on_mouse_entered():
	AudioManager.play_sfx("HOVER_BUTTON")
