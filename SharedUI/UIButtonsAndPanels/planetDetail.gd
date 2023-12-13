extends PanelContainer

@onready var planetName = $VBox/Label
@onready var planetType = $VBox/PlanetType/Type
@onready var hydro = $VBox/Hydrogen/Amount
@onready var base = $VBox/Base/Amount
@onready var prec = $VBox/Precious/Amount

var currentPlanet = null

#@export var p_scale : float = 1.0
#@export var orbit_num : int = 1.0
#@export var orbital_speed : float = 1.0
#@export var p_name : String = "Unamed Planet"
#@export var p_descript : String = "Lava Planet" 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !(currentPlanet == null):
		updateNumbers()
		

func updateUI(planetRef):
	currentPlanet = planetRef
	var resourceDict = currentPlanet.get_resource_abundance()
	print(resourceDict)
	planetName.set_text(planetRef.p_name)
	planetType.set_text(planetRef.p_descript)
	
	updateNumbers()

func updateNumbers():
	var resourceDict = currentPlanet.get_resource_abundance()
	hydro.set_text(str(resourceDict[Constants.HYDROGEN]))
	base.set_text(str(resourceDict[Constants.BASE_METAL]))
	prec.set_text(str(resourceDict[Constants.PRECIOUS_METAL]))

func _on_hidden():
	currentPlanet = null
