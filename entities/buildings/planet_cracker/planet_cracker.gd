class_name PlanetCracker
extends AbstractBuilding


var _planet: Planet:
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
	var hydrogen_extracted = _planet.extract_resource(Constants.HYDROGEN)
	var base_metals_extracted = _planet.extract_resource(Constants.BASE_METAL)
	var precious_metals_extracted = _planet.extract_resource(Constants.PRECIOUS_METAL)

	return {
		Constants.HYDROGEN: hydrogen_extracted,
		Constants.BASE_METAL: base_metals_extracted,
		Constants.PRECIOUS_METAL: precious_metals_extracted
	}
