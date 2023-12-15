extends PanelContainer

@onready var buildingName = $VBox/HBox/BuildingName
@onready var buildingIcon = $VBox/TextureRect
@onready var description = $VBox/HBoxContainer2/Description

@onready var prodPower = $VBox/HBoxContainer/Produce/Power/ProdPower
@onready var prodBase = $VBox/HBoxContainer/Produce/Base/ProdBase
@onready var prodPrec = $VBox/HBoxContainer/Produce/Prec/ProdPrec
@onready var prodAnti = $VBox/HBoxContainer/Produce/Anti/ProdAnti

@onready var costPower = $VBox/HBoxContainer/Costs/Power/CostPower
@onready var costBase = $VBox/HBoxContainer/Costs/Base/CostBase
@onready var costPrec = $VBox/HBoxContainer/Costs/Prec/CostPrec
@onready var costAnti = $VBox/HBoxContainer/Costs/Anti/CostAnti

@onready var prodPowerCont = $VBox/HBoxContainer/Produce/Power
@onready var prodBaseCont = $VBox/HBoxContainer/Produce/Base
@onready var prodPrecCont = $VBox/HBoxContainer/Produce/Prec
@onready var prodAntiCont = $VBox/HBoxContainer/Produce/Anti

@onready var costPowerCont = $VBox/HBoxContainer/Costs/Power
@onready var costBaseCont = $VBox/HBoxContainer/Costs/Base
@onready var costPrecCont = $VBox/HBoxContainer/Costs/Prec
@onready var costAntiCont = $VBox/HBoxContainer/Costs/Anti

@onready var timeCont = $VBox/HBoxContainer/Produce/Time
@onready var timeLabel = $VBox/HBoxContainer/Produce/Time/ProdTime

var buildingInfo
var buildingRef
var buildingArray = Info.BUILDING_INFO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func setupScene(building):
	buildingRef = building
	costAntiCont.hide()
	costBaseCont.hide()
	costPrecCont.hide()
	costPowerCont.hide()
	prodAntiCont.hide()
	prodBaseCont.hide()
	prodPrecCont.hide()
	prodPowerCont.hide()
	match building:
		"Gigafactory":
			buildingInfo = buildingArray.filter(func (b): return b.type == Constants.BUILDING_GIGAFACTORY)[0]
			timeCont.show()
			timeLabel.text = str(snapped(buildingInfo.build_speedup_factor, 1)) + " x"
		"Fusion Reactor":
			buildingInfo = buildingArray.filter(func (b): return b.type == Constants.BUILDING_FUSION_REACTOR)[0]
		"Celestial Extractor":
			buildingInfo = buildingArray.filter(func (b): return b.type == Constants.BUILDING_CELESTIAL_EXTRACTOR)[0]
		"Dyson Swarm":
			buildingInfo = buildingArray.filter(func (b): return b.type == Constants.BUILDING_DYSON_SWARM)[0]
		"Magnetic Bore":
			buildingInfo = buildingArray.filter(func (b): return b.type == Constants.BUILDING_MAGNETIC_BORE)[0]
		"Antimatter Factory":
			buildingInfo = buildingArray.filter(func (b): return b.type == Constants.BUILDING_ANTIMATTER_FACTORY)[0]
		"Stellar Accelerator":
			buildingInfo = buildingArray.filter(func (b): return b.type == Constants.BUILDING_STELLAR_ACCELERATOR)[0]
		"Starlifter":
			buildingInfo = buildingArray.filter(func (b): return b.type == Constants.BUILDING_STARLIFTER)[0]
	
	var buildCostDict = buildingInfo.operational_costs
	var buildProdDict = buildingInfo.produces
	
	buildingName.text = building
	buildingIcon.set_texture(load(Constants.ICONS[building]))
	description.set_text(buildingInfo.description)
	
	if buildCostDict.has(Constants.POWER):
		costPowerCont.show()
		costPower.text = str(buildCostDict[Constants.POWER])
	if buildCostDict.has(Constants.BASE_METAL):
		costBaseCont.show()
		costBase.text = str(buildCostDict[Constants.BASE_METAL])
	if buildCostDict.has(Constants.PRECIOUS_METAL):
		costPrecCont.show()
		costPrec.text = str(buildCostDict[Constants.PRECIOUS_METAL])
	if buildCostDict.has(Constants.ANTIMATTER):
		costAntiCont.show()
		costAnti.text = str(buildCostDict[Constants.ANTIMATTER])
	
	if buildProdDict.has(Constants.POWER):
		prodPowerCont.show()
		prodPower.text = str(buildProdDict[Constants.POWER])
	if buildProdDict.has(Constants.BASE_METAL):
		prodBaseCont.show()
		prodBase.text = str(buildProdDict[Constants.BASE_METAL])
	if buildProdDict.has(Constants.PRECIOUS_METAL):
		prodPrecCont.show()
		prodPrec.text = str(buildProdDict[Constants.PRECIOUS_METAL])
	if buildProdDict.has(Constants.ANTIMATTER):
		prodAntiCont.show()
		prodAnti.text = str(buildProdDict[Constants.ANTIMATTER])


func _on_remove_pressed():
	EventBus.emit_signal("destroyed", buildingRef)
	hide()
