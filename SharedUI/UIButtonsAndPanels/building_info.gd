extends PanelContainer


const MESSAGE_CANNOT_BE_ACTIVATED = "Structure cannot be activated at the moment!"


@onready var enableButton = $VBox/HBoxContainer3/Enable
@onready var disableButton = $VBox/HBoxContainer3/Disable

@onready var buildingName = $VBox/HBox/BuildingName
@onready var buildingIcon = $VBox/TextureRect
@onready var description = $VBox/HBoxContainer2/Description

@onready var prodPower = $VBox/HBoxContainer/Produce/Power/ProdPower
@onready var prodBase = $VBox/HBoxContainer/Produce/Base/ProdBase
@onready var prodPrec = $VBox/HBoxContainer/Produce/Prec/ProdPrec
@onready var prodAnti = $VBox/HBoxContainer/Produce/Anti/ProdAnti

@onready var costHydro = $VBox/HBoxContainer/Costs/Hydro/CostHydro
@onready var costPower = $VBox/HBoxContainer/Costs/Power/CostPower
@onready var costBase = $VBox/HBoxContainer/Costs/Base/CostBase
@onready var costPrec = $VBox/HBoxContainer/Costs/Prec/CostPrec
@onready var costAnti = $VBox/HBoxContainer/Costs/Anti/CostAnti

@onready var prodPowerCont = $VBox/HBoxContainer/Produce/Power
@onready var prodBaseCont = $VBox/HBoxContainer/Produce/Base
@onready var prodPrecCont = $VBox/HBoxContainer/Produce/Prec
@onready var prodAntiCont = $VBox/HBoxContainer/Produce/Anti

@onready var costHydroCont = $VBox/HBoxContainer/Costs/Hydro
@onready var costPowerCont = $VBox/HBoxContainer/Costs/Power
@onready var costBaseCont = $VBox/HBoxContainer/Costs/Base
@onready var costPrecCont = $VBox/HBoxContainer/Costs/Prec
@onready var costAntiCont = $VBox/HBoxContainer/Costs/Anti

@onready var timeCont = $VBox/HBoxContainer/Produce/Time
@onready var timeLabel = $VBox/HBoxContainer/Produce/Time/ProdTime
@onready var indicator = $Indicator

var buildingInfo
var buildingRef
var buildingArray = Info.BUILDING_INFO

func _ready():
	EventBus.connect("planet_nav_button_pressed", Callable(self, "_on_EB_planet_nav_button_pressed"))

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
	timeCont.hide()
	buildingInfo = building
	if buildingInfo.type == "Gigafactory":
		buildingInfo = building #buildingArray.filter(func (b): return b.type == Constants.BUILDING_GIGAFACTORY)[0]
		timeCont.show()
		timeLabel.text = str(snapped(buildingInfo.build_speedup_factor, 1)) + " x"
	
	var buildCostDict = buildingInfo.operational_costs
	var buildProdDict = buildingInfo.produces
	
	buildingName.text = building.type
	buildingIcon.set_texture(load(Constants.ICONS[building.type]))
	description.set_text(buildingInfo.description)
	
	if (buildingInfo.is_active):
		indicator.modulate = Color(0.1,1,0.1,1)
		disableButton.show()
		enableButton.hide()
		
	if !(buildingInfo.is_active):
		enableButton.show()
		disableButton.hide()
		indicator.modulate = Color(1,0.1,0.1,1)
	
	if !(buildingInfo.is_constructed()):
		enableButton.disabled = true
	if (buildingInfo.is_constructed()):
		enableButton.disabled = false
	
	if buildCostDict.has(Constants.HYDROGEN):
		costHydroCont.show()
		costHydro.text = str(buildCostDict[Constants.HYDROGEN])
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


func _on_disable_pressed():
	buildingInfo.set_is_active(false)
	if (buildingInfo.is_active):
		indicator.modulate = Color(0.1,1,0.1,1)
	if !(buildingInfo.is_active):
		indicator.modulate = Color(1,0.1,0.1,1)
	disableButton.hide()
	enableButton.show()


func _on_enable_pressed():
	if not buildingInfo.can_be_activated():
		EventBus.feedback_message.emit(MESSAGE_CANNOT_BE_ACTIVATED)
		return
		
	buildingInfo.set_is_active(true)
	if (buildingInfo.is_active):
		indicator.modulate = Color(0.1,1,0.1,1)
	if !(buildingInfo.is_active):
		indicator.modulate = Color(1,0.1,0.1,1)
	enableButton.hide()
	disableButton.show()

func _on_EB_planet_nav_button_pressed(_planet_ref):
	hide()

func _on_close_button_pressed():
	close()


func close():
	var t = create_tween()
	t.tween_property(self, "modulate", Color.TRANSPARENT, 0.25)
	await t.finished
	hide()


func open():
	var t = create_tween()
	modulate = Color.TRANSPARENT
	show()
	t.tween_property(self, "modulate", Color.WHITE, 0.25)
	await t.finished
