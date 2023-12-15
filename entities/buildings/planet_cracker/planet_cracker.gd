class_name PlanetCracker
extends AbstractBuilding


const RESOURCES_PER_EXTRACTION = 100


@onready var _planet: Planet = get_node("/root/ROOT/SolarSystem/Planets/P1"):
	set = assign_to,
	get = get_assigned_planet


func _ready():
	super()


func assign_to(planet: Planet) -> void:
	_planet = planet
	_planet.add_planet_cracker(self)


func get_assigned_planet() -> Planet:
	return _planet


func next_extraction() -> Dictionary:
	var hydrogen_extracted = _planet.extract_resource(Constants.HYDROGEN, int(RESOURCES_PER_EXTRACTION * _planet.get_hydrogen_percentage()))
	var base_metals_extracted = _planet.extract_resource(Constants.BASE_METAL, int(RESOURCES_PER_EXTRACTION * _planet.get_base_metals_percentage()))
	var precious_metals_extracted = _planet.extract_resource(Constants.PRECIOUS_METAL, int(RESOURCES_PER_EXTRACTION * _planet.get_precious_metals_percentage()))

	return {
		Constants.HYDROGEN: hydrogen_extracted,
		Constants.BASE_METAL: base_metals_extracted,
		Constants.PRECIOUS_METAL: precious_metals_extracted
	}
