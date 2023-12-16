extends Resource
class_name Constants


# Building tiers
enum Tiers {
	TIER_0,
	TIER_1,
	TIER_2,
	TIER_3
}


# Building types
const BUILDING_PLANET_CRACKER = "Planet Cracker"
const BUILDING_GIGAFACTORY = "Gigafactory"
const BUILDING_FUSION_REACTOR = "Fusion Reactor"
const BUILDING_CELESTIAL_EXTRACTOR = "Celestial Extractor"
const BUILDING_DYSON_SWARM = "Dyson Swarm"
const BUILDING_MAGNETIC_BORE = "Magnetic Bore"
const BUILDING_ANTIMATTER_FACTORY = "Antimatter Factory"
const BUILDING_STELLAR_ACCELERATOR = "Stellar Accelerator"
const BUILDING_STARLIFTER = "Starlifter"

# Building icons
const ICONS = {
	"PlanetCracker" : "res://Assets/buildings/PlanetCracker.png",
	"Gigafactory" : "res://Assets/buildings/Factory.png",
	"Fusion Reactor" : "res://Assets/buildings/FusionReactor.png" ,
	"Celestial Extractor" : "res://Assets/Placeholder 50x50.png" ,
	"Dyson Swarm" : "res://Assets/Placeholder 50x50.png" ,
	"Magnetic Bore" : "res://Assets/buildings/MagneticBore.png" ,
	"Antimatter Factory" : "res://Assets/Placeholder 50x50.png" ,
	"Stellar Accelerator" : "res://Assets/buildings/StellarAccelerator.png" ,
	"Starlifter" : "res://Assets/Placeholder 50x50.png"
}

# Resource types
const ANTIMATTER = preload("res://entities/resources/antimatter.tres")
const BASE_METAL = preload("res://entities/resources/base_metal.tres")
const HYDROGEN = preload("res://entities/resources/hydrogen.tres")
const POWER = preload("res://entities/resources/power.tres")
const PRECIOUS_METAL = preload("res://entities/resources/precious_metal.tres")
const UNOBTANIUM = preload("res://entities/resources/unobtanium.tres")
