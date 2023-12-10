class_name PlanetCracker
extends AbstractBuilding


@onready var planet = get_node("/root/ROOT/SolarSystem/Planets/P1")


func _ready():
	super()
	_is_constructed = true
	is_active = true
	produces[Constants.HYDROGEN] = 10


