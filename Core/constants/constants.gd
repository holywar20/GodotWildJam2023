extends Resource
class_name Constants

const DANGER_TIME = 10

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

# Building descriptions
const BUILDING_PLANET_CRACKER_DESCRIPTION = "[center]Harvests available hydrogen, base metals, and precious metals from a planet.[/center]"
const BUILDING_GIGAFACTORY_DESCRIPTION = "[center]Speeds up build times of other structures. Effect is cumulative.[/center]"
const BUILDING_FUSION_REACTOR_DESCRIPTION = "[center]Produces a small amount of power to drive structures.[/center]"
const BUILDING_CELESTIAL_EXTRACTOR_DESCRIPTION = "[center]Pulls heavier elements out of the star for use as resources.[/center]"
const BUILDING_DYSON_SWARM_DESCRIPTION = "[center]Extracts a large amount of power to drive structures. Can only build one.[/center]"
const BUILDING_MAGNETIC_BORE_DESCRIPTION = "[center]Mines available gas clouds to fuel your star.[/center]"
const BUILDING_STELLAR_ACCELERATOR_DESCRIPTION = "[center]Generates antimatter to power other, more complex structures.[/center]"
const BUILDING_STARLIFTER_DESCRIPTION = "[center]The pinnacle of technology, allows you to extract the prize of having gestated a successful star: Unobtanium![/center]"

# Building icons
const ICONS = {
	"PlanetCracker" : "res://Assets/buildings/PlanetCracker.png",
	"Gigafactory" : "res://Assets/buildings/Factory.png",
	"Fusion Reactor" : "res://Assets/buildings/FusionReactor.png" ,
	"Celestial Extractor" : "res://Assets/buildings/CelestialExtractor.png" ,
	"Dyson Swarm" : "res://Assets/buildings/DysonSwarmIcon.png" ,
	"Magnetic Bore" : "res://Assets/buildings/MagneticBore.png" ,
	"Antimatter Factory" : "res://Assets/Placeholder 50x50.png" ,
	"Stellar Accelerator" : "res://Assets/buildings/StellarAccelerator.png" ,
	"Starlifter" : "res://Assets/buildings/StarLifter.png"
}

# Resource types
const ANTIMATTER = preload("res://entities/resources/antimatter.tres")
const BASE_METAL = preload("res://entities/resources/base_metal.tres")
const HYDROGEN = preload("res://entities/resources/hydrogen.tres")
const POWER = preload("res://entities/resources/power.tres")
const PRECIOUS_METAL = preload("res://entities/resources/precious_metal.tres")
const UNOBTANIUM = preload("res://entities/resources/unobtanium.tres")

const ANTIMATTER_LABEL = "Antimatter"
const BASE_METAL_LABEL = "Base Metal"
const HYDROGEN_LABEL = "Hydrogen"
const POWER_LABEL = "Power"
const PRECIOUS_METAL_LABEL = "Precious Metal"
const UNOBTANIUM_LABEL = "Unobtanium"

static func get_building_description( b_type : String ):
	match b_type:
		BUILDING_PLANET_CRACKER:
			return BUILDING_PLANET_CRACKER_DESCRIPTION
		BUILDING_GIGAFACTORY:
			return BUILDING_GIGAFACTORY_DESCRIPTION
		BUILDING_FUSION_REACTOR:
			return BUILDING_FUSION_REACTOR_DESCRIPTION
		BUILDING_CELESTIAL_EXTRACTOR:
			return BUILDING_CELESTIAL_EXTRACTOR_DESCRIPTION
		BUILDING_DYSON_SWARM:
			return BUILDING_DYSON_SWARM_DESCRIPTION
		BUILDING_MAGNETIC_BORE:
			return BUILDING_MAGNETIC_BORE_DESCRIPTION
		BUILDING_STELLAR_ACCELERATOR:
			return BUILDING_STELLAR_ACCELERATOR_DESCRIPTION
		BUILDING_STARLIFTER:
			return BUILDING_STARLIFTER_DESCRIPTION
