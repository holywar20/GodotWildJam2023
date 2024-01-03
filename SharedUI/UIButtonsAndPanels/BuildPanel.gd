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
@onready var GigafactoryButton = $VBox/ScrollContainer/VBoxContainer/Gigafactory
@onready var FusionReactorButton = $VBox/ScrollContainer/VBoxContainer/FusionReactor

var isOpen = false

var tier2 = [CelestialExtractorButton , DysonSwarmButton , MagneticBoreButton]
var tier3 = [AntimatterFactoryButton , StellarAcceleratorButton , StarlifterButton]

var currentTier = 1

func _ready():
	# Joe this code breaks on star_transitioned
	EventBus.connect("star_transitioned", Callable(self, "_on_EB_star_transitioned"))
	EventBus.connect("game_restart", Callable(self, "_on_EB_game_restart"))

	GigafactoryButton.tooltip_text = _make_control_tooltip_friendly(Constants.BUILDING_GIGAFACTORY_DESCRIPTION)
	FusionReactorButton.tooltip_text = _make_control_tooltip_friendly(Constants.BUILDING_FUSION_REACTOR_DESCRIPTION)
	CelestialExtractorButton.tooltip_text = _make_control_tooltip_friendly(Constants.BUILDING_CELESTIAL_EXTRACTOR_DESCRIPTION)
	DysonSwarmButton.tooltip_text = _make_control_tooltip_friendly(Constants.BUILDING_DYSON_SWARM_DESCRIPTION)
	MagneticBoreButton.tooltip_text = _make_control_tooltip_friendly(Constants.BUILDING_MAGNETIC_BORE_DESCRIPTION)
	StellarAcceleratorButton.tooltip_text = _make_control_tooltip_friendly(Constants.BUILDING_STELLAR_ACCELERATOR_DESCRIPTION)
	StarlifterButton.tooltip_text = _make_control_tooltip_friendly(Constants.BUILDING_STARLIFTER_DESCRIPTION)


func _make_control_tooltip_friendly(content: String) -> String:
	const TO_REPLACE: Array = [
		"[center]",
		"[/center]",
	]

	var to_return: String = content

	for replacing in TO_REPLACE:
		to_return = to_return.replace(replacing, "")

	return to_return


func _on_EB_game_restart():
	CelestialExtractorButton.hide()
	DysonSwarmButton.hide()
	MagneticBoreButton.hide()
	StellarAcceleratorButton.hide()
	StarlifterButton.hide()

func _on_EB_star_transitioned(_state):
	currentTier = _state + 1
	if currentTier == 2:
		CelestialExtractorButton.show()
		DysonSwarmButton.show()
		MagneticBoreButton.show()
	if currentTier == 3:
		#AntimatterFactoryButton.show()
		StellarAcceleratorButton.show()
	if currentTier == 4:
		StarlifterButton.show()

func openClose():
	var t = create_tween()
	if(isOpen):
		t.tween_property(self, "modulate", Color.TRANSPARENT, 0.25)
		await t.finished
		hide()
	else:
		modulate = Color.TRANSPARENT
		show()
		t.tween_property(self, "modulate", Color.WHITE, 0.25)
		await t.finished

	isOpen = !isOpen


func openCloseNoTransition():
	if(isOpen):
		hide()
	else:
		show()

	isOpen = !isOpen
