extends CanvasLayer

# Buttons
@onready var buildMenu = $Hbox/MiddleSection/CenterContainer/SubMenuContainer/BuildMenu
@onready var powerMenu = $Hbox/MiddleSection/CenterContainer/SubMenuContainer/PowerMenu

# Panels
@onready var navPanel = $Hbox/MiddleSection/CenterContainer/VBoxContainer/NavPanel/ScrollContainer/NavContainer
@onready var buildQueue = $Hbox/MiddleSection/CenterContainer/VBoxContainer/BuildPanel/ScrollContainer/BuildQueue

# Top bar resources
@onready var powerAmount = $Hbox/MiddleSection/TopBorder/Panel/ResContainer/Power/PowerContainer/Panel/HBoxContainer/Amount
@onready var powerChange = $Hbox/MiddleSection/TopBorder/Panel/ResContainer/Power/PowerContainer/Panel/HBoxContainer/Change
@onready var baseAmount = $Hbox/MiddleSection/TopBorder/Panel/ResContainer/BaseMetals/BaseContainer/Panel/Numbers/Amount
@onready var baseChange = $Hbox/MiddleSection/TopBorder/Panel/ResContainer/BaseMetals/BaseContainer/Panel/Numbers/Change
@onready var preciousAmount = $Hbox/MiddleSection/TopBorder/Panel/ResContainer/PreciousMetas/PreciousContainer/Panel/Numbers/Amount
@onready var preciousChange = $Hbox/MiddleSection/TopBorder/Panel/ResContainer/PreciousMetas/PreciousContainer/Panel/Numbers/Change
@onready var antimatterAmount = $Hbox/MiddleSection/TopBorder/Panel/ResContainer/Antimatter/AntimatterContainer/Panel/Numbers/Amount
@onready var antimatterChange = $Hbox/MiddleSection/TopBorder/Panel/ResContainer/Antimatter/AntimatterContainer/Panel/Numbers/Change

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_build_menu_pressed():
	if (powerMenu.isOpen):
		powerMenu.openClose()
	buildMenu.openClose()


func _on_power_menu_pressed():
	if (buildMenu.isOpen):
		buildMenu.openClose()
	powerMenu.openClose()


func _on_exit_pressed():
	pass # Replace with function body.
