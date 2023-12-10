extends Resource
class_name StellarConstants

const TIER_STATES = {
	Constants.Tiers.TIER_0 : {
		'metadata' : {
			'star_class' : "Brown Dwarf",
			'description' : """This star is a brown dwarf. It is not a star at all but rather on the boundary between planet and star. While still warm from its formation, it lacks the proper mass to ignite fusion on its own.

It is up to you to light this star, and bring illumination to a universe that is now dying to the pitiless cruelty of heat death.
""",
			'temperature' : 1500,
			'luminosity' : 0.0001, # 1/10,000th of the sun
			'mass' : 0.01,
			'scale' : 0.5,
			'gradient_path' : 'res://entities/star/gradients/t0.tres'
		},
		'corona' : {
			'color': Vector3( 0.69 , 0.0 , 0.875 ),
			'timeFactor' : 0.09,
			'flareAmount' : 10,
			'size' : 4.8,
			'spiky' : 27.1,
			'gas' : 1.8
		},
		'star' : {
			'rotationSpeed' : 0.1,
			'cellSize' : 5.0,
			'wormCellSize' : 1.7,
			'vorCellSize' : 4.1,
			'convectionSpeed' : 0.05,
			'stretchFactor' : 4.091,
			'flowFactor' : 0.18
		}
	},
	Constants.Tiers.TIER_1 : {
		'metadata' : {
			'star_class' : "Red Dwarf",
			'description' : """This star is a red dwarf. It is a small, cool star that is very common in the universe. It is not very luminous, but it is very long lived. It is the most common type of star in the universe.""",
			'temperature' : 3000,
			'luminosity' : 0.001, # 1 / 1000th of the sun
			'mass' : 0.08,
			'scale' : 1.0
		},
		'corona' : {
			'color': Vector3( 0.69 , 0.0 , 0.875 ),
			'timeFactor' : 0.09,
			'flareAmount' : 10,
			'size' : 4.8,
			'spiky' : 27.1,
			'gas' : 1.8
		},
		'star' : {
			'rotationSpeed' : 0.1,
			'cellSize' : 5.0,
			'wormCellSize' : 1.7,
			'vorCellSize' : 4.1,
			'convectionSpeed' : 0.1,
			'stretchFactor' : 1.0,
			'flowFactor' : 0.18
		}
	},
	Constants.Tiers.TIER_2 : {
		'metadata' : {
			'star_class' : "Orange Dwarf",
			'description' : """""",
			'temperature' : 4500,
			'luminosity' : 0.5, # 1/2 the sun
			'mass' : 0.5,
			'scale' : 1.5
		},
		'corona' : {

		},
		'star' : {

		}
	},
	Constants.Tiers.TIER_3 : {
		'metadata' : {
			'star_class' : "Yellow Dwarf",
			'description' : """""",
			'temperature' : 6000,
			'luminosity' : 0.1, # 1/2 the sun
			'mass' : 1.0,
			'scale' : 2.0
		},
		'corona' : {},
		'star' : {}
	}
}

static func get_tier_state(teir : int) -> Dictionary:
	return TIER_STATES[teir]

static func get_blank_tier_data() -> Dictionary:
	var new_state = {
		'metadata' : {
			'temperature' : null,
			'luminosity' : null, # 1/10,000th of the sun
			'mass' : null,
			'scale' :null,
			'gradient_path' : null
		},
		'corona' : {
			'color': null,
			'timeFactor' : null,
			'flareAmount' : null,
			'size' : null,
			'spiky' : null,
			'gas' : null
		},
		'star' : {
			'rotationSpeed' : null,
			'cellSize' : null,
			'wormCellSize' : null,
			'vorCellSize' : null,
			'convectionSpeed' :  null,
			'stretchFactor' : null,
			'flowFactor' :  null
		}
	}
	
	return new_state
