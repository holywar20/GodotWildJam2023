extends PanelContainer

# Info Labels
@onready var menuLabel = $VBox/MenuName

# Buttons
@onready var CelestialExtractorButton = $VBox/ScrollContainer/VBoxContainer/CelestialExtractor
@onready var DysonSwarmButton = $VBox/ScrollContainer/VBoxContainer/DysonSwarm
@onready var MagneticBoreButton = $VBox/ScrollContainer/VBoxContainer/MagneticBore
@onready var AntimatterFactoryButton = $VBox/ScrollContainer/VBoxContainer/AntimatterFactory
@onready var StellarAcceleratorButton = $VBox/ScrollContainer/VBoxContainer/StellarAccelerator
@onready var StarlifterButton = $VBox/ScrollContainer/VBoxContainer/Starlifter


var isOpen = false

var tier2 = [CelestialExtractorButton , DysonSwarmButton , MagneticBoreButton]
var tier3 = [AntimatterFactoryButton , StellarAcceleratorButton , StarlifterButton]

var currentTier = 0

func _ready():
	# Joe this code breaks on star_transitioned
	EventBus.connect("star_transitioned", Callable(self, "_on_EB_star_transitioned"))

func _on_EB_star_transitioned(_state):
	currentTier += 1
	print(_state)
	print("Tier " + str(currentTier))
	if currentTier == 2:
		CelestialExtractorButton.show()
		DysonSwarmButton.show()
		MagneticBoreButton.show()
	if currentTier == 3:
		AntimatterFactoryButton.show()
		StellarAcceleratorButton.show()
		StarlifterButton.show()

func openClose():
	if(isOpen):
		hide()
	else:
		show()
	isOpen = !isOpen
