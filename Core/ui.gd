extends CanvasLayer

# Buttons
@onready var buildMenu = $Hbox/MiddleSection/CenterContainer/SubMenuContainer/BuildMenu
@onready var boreMenu = $Hbox/MiddleSection/CenterContainer/SubMenuContainer/BoreMenu
@onready var boreMenuButton = $OpButtonContainer/Bore

# Panels
@onready var navPanel = $Hbox/MiddleSection/CenterContainer/VBoxContainer/NavPanel
@onready var buildQueue = $Hbox/MiddleSection/CenterContainer/VBoxContainer/BuildPanel/VBoxContainer/ScrollContainer/BuildQueue
@onready var planetDetailContainer = $Hbox/MiddleSection/CenterContainer/PlanetDetails
@onready var planetDetailPanel = $Hbox/MiddleSection/CenterContainer/PlanetDetails/PlanetContainer
@onready var planetCrackerPanel = $Hbox/MiddleSection/CenterContainer/PlanetDetails/CrackerMenu
@onready var buildingInfo = $Hbox/MiddleSection/CenterContainer/BuildingInfo/BuildingInfo
@onready var confirmQuit = $Popup

# Top bar resources
@onready var powerAmount = $Hbox/MiddleSection/TopBorder/Panel/ResContainer/Power/PowerContainer/Panel/HBoxContainer/Amount
@onready var powerChange = $Hbox/MiddleSection/TopBorder/Panel/ResContainer/Power/PowerContainer/Panel/HBoxContainer/Change
@onready var hydrogenAmount = $Hbox/MiddleSection/TopBorder/Panel/ResContainer/Hydrogen/HydrogenContainer/Panel/Numbers/Amount
@onready var hydrogenChange = $Hbox/MiddleSection/TopBorder/Panel/ResContainer/Hydrogen/HydrogenContainer/Panel/Numbers/Change
@onready var baseAmount = $Hbox/MiddleSection/TopBorder/Panel/ResContainer/BaseMetals/BaseContainer/Panel/Numbers/Amount
@onready var baseChange = $Hbox/MiddleSection/TopBorder/Panel/ResContainer/BaseMetals/BaseContainer/Panel/Numbers/Change
@onready var preciousAmount = $Hbox/MiddleSection/TopBorder/Panel/ResContainer/PreciousMetas/PreciousContainer/Panel/Numbers/Amount
@onready var preciousChange = $Hbox/MiddleSection/TopBorder/Panel/ResContainer/PreciousMetas/PreciousContainer/Panel/Numbers/Change
@onready var antimatterAmount = $Hbox/MiddleSection/TopBorder/Panel/ResContainer/Antimatter/AntimatterContainer/Panel/Numbers/Amount
@onready var antimatterChange = $Hbox/MiddleSection/TopBorder/Panel/ResContainer/Antimatter/AntimatterContainer/Panel/Numbers/Change

@onready var currentEventLabel = $Hbox/MiddleSection/TopBorder/Panel/ResContainer/PanelContainer/VBoxContainer/CurrentEventLabel
@onready var resourceWarning = $Warning

var feedbackMessage = preload("res://SharedUI/feedback_message_scene.tscn")
var buildQueueItem = preload("res://SharedUI/BuildQueueItem.tscn")
var gasCloudInfo = preload("res://SharedUI/gasCloudPopUp.tscn")
var selectedPlanetRef
var lastSelectedBuilding


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("construction_requested", Callable(self, "_on_EB_construction_requested"))
	EventBus.connect("resources_reported", Callable(self, "_on_EB_resources_reported"))
	EventBus.connect("construction_started", Callable(self, "_on_EB_construction_started"))
	EventBus.connect("constructed", Callable(self, "_on_EB_constructed"))
	EventBus.connect("camera_move_to_planet_finished", Callable(self, "_on_EB_camera_move_to_planet_finished"))
	EventBus.connect("planet_nav_button_pressed", Callable(self, "_on_EB_planet_nav_button_pressed"))
	EventBus.connect("return_to_star_pressed", Callable(self, "_on_EB_return_to_star_pressed"))
	EventBus.connect("feedback_message", Callable(self, "_on_EB_feedback_message"))
	EventBus.connect("building_pressed", Callable(self, "_on_EB_building_pressed"))
	EventBus.connect("event_started", Callable(self, "_on_EB_event_started"))
	EventBus.connect("event_concluded", Callable(self, "_on_EB_event_concluded"))
	EventBus.connect("gas_cloud_hovering", Callable(self, "_on_EB_gas_cloud_hovering"))
	EventBus.connect("planet_depletion", Callable(self, "_on_EB_planet_depletion"))
	EventBus.game_restart.connect(_on_game_restart)
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
		powerChange.set_text("")

	# Hydrogen
	if int(hydrogenChange.get_text()) < 0:
		hydrogenChange.modulate = Color(1,0.1,0.1,1)
	elif int(hydrogenChange.get_text()) > 0:
		hydrogenChange.modulate = Color(0.1,1,0.1,1)
		hydrogenChange.set_text("+" + hydrogenChange.get_text())
	else:
		hydrogenChange.modulate = Color(1,1,1,1)
		hydrogenChange.set_text("")

	# Base metals
	if int(baseChange.get_text()) < 0:
		baseChange.modulate = Color(1,0.1,0.1,1)
	if int(baseChange.get_text()) > 0:
		baseChange.modulate = Color(0.1,1,0.1,1)
		baseChange.set_text("+" + baseChange.get_text())
	if int(baseChange.get_text()) == 0:
		baseChange.modulate = Color(1,1,1,1)
		baseChange.set_text("")
	
	# Precious metals
	if int(preciousChange.get_text()) < 0:
		preciousChange.modulate = Color(1,0.1,0.1,1)
	if int(preciousChange.get_text()) > 0:
		preciousChange.modulate = Color(0.1,1,0.1,1)
		preciousChange.set_text("+" + preciousChange.get_text())
	if int(preciousChange.get_text()) == 0:
		preciousChange.modulate = Color(1,1,1,1)
		preciousChange.set_text("")
	
	# Antimatter
	if int(antimatterChange.get_text()) < 0:
		antimatterChange.modulate = Color(1,0.1,0.1,1)
	if int(antimatterChange.get_text()) > 0:
		antimatterChange.modulate = Color(0.1,1,0.1,1)
		antimatterChange.set_text("+" + antimatterChange.get_text())
	if int(antimatterChange.get_text()) == 0:
		antimatterChange.modulate = Color(1,1,1,1)
		antimatterChange.set_text("")

func _on_EB_resources_reported(resourcesDict):
	var oldPower = powerAmount.get_text()
	var oldHydrogen = hydrogenAmount.get_text()
	var oldBase = baseAmount.get_text()
	var oldPrecious = preciousAmount.get_text()
	var oldAntimatter = antimatterAmount.get_text()
	
	var newPower = resourcesDict[Constants.POWER]
	var newHydrogen = resourcesDict[Constants.HYDROGEN]
	var newBase = resourcesDict[Constants.BASE_METAL]
	var newPrecious = resourcesDict[Constants.PRECIOUS_METAL]
	var newAntimatter = resourcesDict[Constants.ANTIMATTER]

	powerChange.set_text(str(int(newPower)-int(oldPower)))
	hydrogenChange.set_text(str(int(newHydrogen)-int(oldHydrogen)))
	baseChange.set_text(str(int(newBase)-int(oldBase)))
	preciousChange.set_text(str(int(newPrecious)-int(oldPrecious)))
	antimatterChange.set_text(str(int(newAntimatter)-int(oldAntimatter)))
	
	powerAmount.set_text(str(newPower))
	hydrogenAmount.set_text(str(newHydrogen))
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
	var queue_item_to_remove = buildQueue.get_children().filter( func (c): return c.building == building )

	if queue_item_to_remove:
		queue_item_to_remove[0].removeSelf()

	if building.type == Constants.BUILDING_MAGNETIC_BORE:
		boreMenuButton.show()


func _on_EB_building_pressed(building):
	if lastSelectedBuilding == building and buildingInfo.is_visible_in_tree():
		buildingInfo.close()
	else:
		buildingInfo.setupScene(building)
		buildingInfo.open()
		lastSelectedBuilding = building

func _on_EB_planet_nav_button_pressed(planetRef):
	selectedPlanetRef = planetRef
	EventBus.planet_selected.emit(planetRef)


func _on_EB_camera_move_to_planet_finished():
	var t = create_tween()
	planetDetailContainer.modulate = Color.TRANSPARENT
	planetDetailContainer.show()
	t.tween_property(planetDetailContainer, "modulate", Color.WHITE, 0.25)
	planetCrackerPanel.updateUI(selectedPlanetRef)
	planetDetailPanel.updateUI(selectedPlanetRef)

func _on_EB_return_to_star_pressed():
	var t = create_tween()
	t.tween_property(planetDetailContainer, "modulate", Color.TRANSPARENT, 0.25)
	await t.finished
	planetDetailContainer.hide()

func _on_EB_feedback_message(text):
	var newMessage = feedbackMessage.instantiate()
	var mousePos = get_viewport().get_mouse_position()
	add_child(newMessage)
	newMessage.beginMessage(text, mousePos)

func _on_EB_gas_cloud_hovering(gas_cloud):
	var newMessage = gasCloudInfo.instantiate()
	var mousePos = get_viewport().get_mouse_position()
	add_child(newMessage)
	newMessage.setupScene(gas_cloud, mousePos)

func _on_EB_planet_depletion(planet):
	resourceWarning.playWarning(planet)

func _on_build_menu_pressed():
	if (boreMenu.isOpen):
		boreMenu.openCloseNoTransition()
	buildMenu.openClose()


func _on_exit_pressed():
	EventBus.game_paused.emit(false)
	confirmQuit.popup()


func _on_bore_pressed():
	if (buildMenu.isOpen):
		buildMenu.openCloseNoTransition()
	boreMenu.openClose()


func _on_EB_event_started(event) -> void:
	currentEventLabel.text = event.type


func _on_EB_event_concluded(_event) -> void:
	currentEventLabel.text = "NONE"


func _on_game_restart() -> void:
	if boreMenu.isOpen:
		boreMenu.openClose()

	if buildMenu.isOpen:
		buildMenu.openClose()

	for item in buildQueue.get_children():
		buildQueue.remove_child(item)
		item.queue_free()

	boreMenuButton.hide()
	currentEventLabel.text = "NONE"
