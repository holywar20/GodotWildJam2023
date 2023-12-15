extends PanelContainer

@onready var planetName = $VBox/Label
@onready var planetType = $VBox/PlanetType/Type
@onready var hydro = $VBox/Hydrogen/Amount
@onready var base = $VBox/Base/Amount
@onready var prec = $VBox/Precious/Amount
@onready var desc = $VBox/Desc

var currentPlanet = null


func _ready():
	pass # Replace with function body.


func _process(_delta):
	if !(currentPlanet == null):
		updateNumbers()
		

func updateUI(planetRef):
	EventBus.planet_selected.emit(planetRef)
	currentPlanet = planetRef
	var resourceDict = currentPlanet.get_resource_abundance()
	print(resourceDict)
	planetName.set_text(planetRef.p_name)
	planetType.set_text(planetRef.p_class)
	desc.set_text(planetRef.p_descript)
	
	updateNumbers()

func updateNumbers():
	var resourceDict = currentPlanet.get_resource_abundance()
	hydro.set_text(str(resourceDict[Constants.HYDROGEN]))
	base.set_text(str(resourceDict[Constants.BASE_METAL]))
	prec.set_text(str(resourceDict[Constants.PRECIOUS_METAL]))

func _on_hidden():
	currentPlanet = null
