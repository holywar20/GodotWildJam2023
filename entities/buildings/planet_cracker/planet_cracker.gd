class_name PlanetCracker
extends AbstractBuilding


const RESOURCES_PER_EXTRACTION = 100


@onready var _planet: Planet = get_node("/root/ROOT/SolarSystem/Planets/P1"):
	set = assign_to

var _hydrogen_percentage: float = 0.33:
	set = set_hydrogen_percentage

var _base_metals_percentage: float = 0.33:
	set = set_base_metals_percentage

var _precious_metals_percentage: float = 0.33:
	set = set_precious_metals_percentage


func _ready():
	super()
	#produces[Constants.HYDROGEN] = 10


func assign_to(planet: Planet) -> void:
	_planet = planet
	_planet.add_planet_cracker()


func next_extraction() -> Dictionary:
	var hydrogen_extracted = _planet.extract_resource(Constants.HYDROGEN, int(RESOURCES_PER_EXTRACTION * _hydrogen_percentage))
	var base_metals_extracted = _planet.extract_resource(Constants.BASE_METAL, int(RESOURCES_PER_EXTRACTION * _base_metals_percentage))
	var precious_metals_extracted = _planet.extract_resource(Constants.PRECIOUS_METAL, int(RESOURCES_PER_EXTRACTION * _precious_metals_percentage))

	return {
		Constants.HYDROGEN: hydrogen_extracted,
		Constants.BASE_METAL: base_metals_extracted,
		Constants.PRECIOUS_METAL: precious_metals_extracted
	}


func set_hydrogen_percentage(value: float) -> void:
	_hydrogen_percentage = value


func set_base_metals_percentage(value: float) -> void:
	_base_metals_percentage = value


func set_precious_metals_percentage(value: float) -> void:
	_precious_metals_percentage = value
