class_name BuildingFactory
extends RefCounted


const SCENE_LOOKUP = {
	Constants.BUILDING_ANTIMATTER_FACTORY: preload("res://entities/buildings/antimatter_factory/antimatter_factory.tscn"),
	Constants.BUILDING_CELESTIAL_EXTRACTOR: preload("res://entities/buildings/celestial_extractor/celestial_extractor.tscn"),
	Constants.BUILDING_DYSON_SWARM: preload("res://entities/buildings/dyson_swarm/dyson_swarm.tscn"),
	Constants.BUILDING_FUSION_REACTOR: preload("res://entities/buildings/fusion_reactor/fusion_reactor.tscn"),
	Constants.BUILDING_GIGAFACTORY: preload("res://entities/buildings/gigafactory/gigafactory.tscn"),
	Constants.BUILDING_MAGNETIC_BORE: preload("res://entities/buildings/magnetic_bore/magnetic_bore.tscn"),
	Constants.BUILDING_PLANET_CRACKER: preload("res://entities/buildings/planet_cracker/planet_cracker.tscn"),
	Constants.BUILDING_STARLIFTER: preload("res://entities/buildings/starlifter/starlifter.tscn"),
	Constants.BUILDING_STELLAR_ACCELERATOR: preload("res://entities/buildings/stellar_accelerator/stellar_accelerator.tscn"),
}


static func create_building(building_type: String):
	if SCENE_LOOKUP.has(building_type):
		return SCENE_LOOKUP[building_type].instantiate()

	return null
