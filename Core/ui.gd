extends CanvasLayer

# Buttons
@onready var buildMenu = $Hbox/MiddleSection/CenterContainer/SubMenuContainer/BuildMenu
@onready var powerMenu = $Hbox/MiddleSection/CenterContainer/SubMenuContainer/PowerMenu

# Panels
@onready var navPanel = $Hbox/MiddleSection/CenterContainer/VBoxContainer/NavPanel
@onready var buildQueue = $Hbox/MiddleSection/CenterContainer/VBoxContainer/BuildPanel/ScrollContainer/BuildQueue
@onready var planetDetailContainer = $Hbox/MiddleSection/CenterContainer/PlanetDetails
@onready var planetDetailPanel = $Hbox/MiddleSection/CenterContainer/PlanetDetails/PlanetContainer
@onready var planetCrackerPanel = $Hbox/MiddleSection/CenterContainer/PlanetDetails/CrackerMenu
@onready var confirmQuit = $Popup

# Top bar resources
@onready var powerAmount = $Hbox/MiddleSection/TopBorder/Panel/ResContainer/Power/PowerContainer/Panel/HBoxContainer/Amount
@onready var powerChange = $Hbox/MiddleSection/TopBorder/Panel/ResContainer/Power/PowerContainer/Panel/HBoxContainer/Change
@onready var baseAmount = $Hbox/MiddleSection/TopBorder/Panel/ResContainer/BaseMetals/BaseContainer/Panel/Numbers/Amount
@onready var baseChange = $Hbox/MiddleSection/TopBorder/Panel/ResContainer/BaseMetals/BaseContainer/Panel/Numbers/Change
@onready var preciousAmount = $Hbox/MiddleSection/TopBorder/Panel/ResContainer/PreciousMetas/PreciousContainer/Panel/Numbers/Amount
@onready var preciousChange = $Hbox/MiddleSection/TopBorder/Panel/ResContainer/PreciousMetas/PreciousContainer/Panel/Numbers/Change
@onready var antimatterAmount = $Hbox/MiddleSection/TopBorder/Panel/ResContainer/Antimatter/AntimatterContainer/Panel/Numbers/Amount
@onready var antimatterChange = $Hbox/MiddleSection/TopBorder/Panel/ResContainer/Antimatter/AntimatterContainer/Panel/Numbers/Change

var buildQueueItem = preload("res://SharedUI/BuildQueueItem.tscn")
var selectedPlanetRef

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("construction_requested", Callable(self, "_on_EB_construction_requested"))
	EventBus.connect("resources_reported", Callable(self, "_on_EB_resources_reported"))
	EventBus.connect("construction_started", Callable(self, "_on_EB_construction_started"))
	EventBus.connect("constructed", Callable(self, "_on_EB_constructed"))
	EventBus.connect("camera_move_to_planet_finished", Callable(self, "_on_EB_camera_move_to_planet_finished"))
	EventBus.connect("planet_nav_button_pressed", Callable(self, "_on_EB_planet_nav_button_pressed"))
	EventBus.connect("return_to_star_pressed", Callable(self, "_on_EB_return_to_star_pressed"))
	navPanel.updateUI()


func updateChangeColours():
	# Power
	if int(powerChange.get_text()) < 0:
		powerChange.modulate = Color(1,0.1,0.1,1)
	if int(powerChange.get_text()) > 0:
		powerChange.modulate = Color(0.1,1,0.1,1)
		powerChange.set_text("+" + powerChange.get_text())
	if int(powerChange.get_text()) == 0:
		powerChange.modulate = Color(1,1,1,1)
		powerChange.set_text("=" + powerChange.get_text())
	
	# Base metals
	if int(baseChange.get_text()) < 0:
		baseChange.modulate = Color(1,0.1,0.1,1)
	if int(baseChange.get_text()) > 0:
		baseChange.modulate = Color(0.1,1,0.1,1)
		baseChange.set_text("+" + baseChange.get_text())
	if int(baseChange.get_text()) == 0:
		baseChange.modulate = Color(1,1,1,1)
		baseChange.set_text("=" + baseChange.get_text())
	
	# Precious metals
	if int(preciousChange.get_text()) < 0:
		preciousChange.modulate = Color(1,0.1,0.1,1)
	if int(preciousChange.get_text()) > 0:
		preciousChange.modulate = Color(0.1,1,0.1,1)
		preciousChange.set_text("+" + preciousChange.get_text())
	if int(preciousChange.get_text()) == 0:
		preciousChange.modulate = Color(1,1,1,1)
		preciousChange.set_text("=" + preciousChange.get_text())
	
	# Antimatter
	if int(antimatterChange.get_text()) < 0:
		antimatterChange.modulate = Color(1,0.1,0.1,1)
	if int(antimatterChange.get_text()) > 0:
		antimatterChange.modulate = Color(0.1,1,0.1,1)
		antimatterChange.set_text("+" + antimatterChange.get_text())
	if int(antimatterChange.get_text()) == 0:
		antimatterChange.modulate = Color(1,1,1,1)
		antimatterChange.set_text("=" + antimatterChange.get_text())

func _on_EB_resources_reported(resourcesDict):
	var oldPower = powerAmount.get_text()
	var oldBase = baseAmount.get_text()
	var oldPrecious = preciousAmount.get_text()
	var oldAntimatter = antimatterAmount.get_text()
	
	var newPower = resourcesDict[Constants.POWER]
	var newBase = resourcesDict[Constants.BASE_METAL]
	var newPrecious = resourcesDict[Constants.PRECIOUS_METAL]
	var newAntimatter = resourcesDict[Constants.ANTIMATTER]
	
	powerChange.set_text(str(int(newPower)-int(oldPower)))
	baseChange.set_text(str(int(newBase)-int(oldBase)))
	preciousChange.set_text(str(int(newPrecious)-int(oldPrecious)))
	antimatterChange.set_text(str(int(newAntimatter)-int(oldAntimatter)))
	
	powerAmount.set_text(str(newPower))
	baseAmount.set_text(str(newBase))
	preciousAmount.set_text(str(newPrecious))
	antimatterAmount.set_text(str(newAntimatter))
	
	updateChangeColours()

func _on_EB_construction_started(building):
	var newBuildItem = buildQueueItem.instantiate()
	newBuildItem.building = building
	buildQueue.add_child(newBuildItem)
	newBuildItem.setName(building.type)


func _on_EB_constructed(building) -> void:
	var queue_item_to_remove = buildQueue.get_children().filter(func (c): return c.building == building)

	if queue_item_to_remove:
		queue_item_to_remove[0].removeSelf()


func _on_EB_planet_nav_button_pressed(planetRef):
	selectedPlanetRef = planetRef
	EventBus.planet_selected.emit(planetRef)


func _on_EB_camera_move_to_planet_finished():
	planetDetailContainer.show()
	planetCrackerPanel.updateUI(selectedPlanetRef)
	planetDetailPanel.updateUI(selectedPlanetRef)

func _on_EB_return_to_star_pressed():
	planetDetailContainer.hide()

func _on_build_menu_pressed():
	if (powerMenu.isOpen):
		powerMenu.openClose()
	buildMenu.openClose()

func _on_power_menu_pressed():
	if (buildMenu.isOpen):
		buildMenu.openClose()
	powerMenu.openClose()


func _on_exit_pressed():
	Input.action_press("ui_pause")
	confirmQuit.popup()
