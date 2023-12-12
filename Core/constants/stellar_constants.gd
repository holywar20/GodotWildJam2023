extends Resource
class_name StellarConstants

const TIER_STATES = {
	Constants.Tiers.TIER_0 : {
		'state_thresholds' : {
			'threshold' : 1000,
			'min_flow_tolerance' : 50,
			'max_flow_tolerance' : 50
		},
		'metadata' : {
			'star_class' : "Brown Dwarf",
			'description' : """This star is a brown dwarf. It is not a star at all but rather on the boundary between planet and star. While still warm from its formation, it lacks the proper mass to ignite fusion on its own.

	It is up to you to light this star, and bring illumination to a universe that is now dying to the pitiless cruelty of heat death.
	""",
			'gradient' : preload("res://entities/star/gradients/t0.tres")
		},
		'interpolated_metadata' : {
			'temperature' : 1500,
			'luminosity' : 0.0001, # 1/10,000th of the sun
			'mass' : 0.01,
			'scale' : 1.5,
		},
		'corona' : {
			'color': Vector3( 0.69 , 0.0 , 0.875 ),
			'timeFactor' : 0.09,
			'flareAmount' : 10,
			'size' : 4.8,
			'spiky' : 27.1,
			'gas' : 1.8
		},
		'star_body' : {
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
		'state_thresholds' : {
			'threshold' : 5000,
			'min_flow_tolerance' : 40,
			'max_flow_tolerance' : 40
		},
		'metadata' : {
			'star_class' : "Red Dwarf",
			'description' : """This star is a red dwarf. It is a small, cool star that is very common in the universe. It is not very luminous, but it is very long lived. It is the most common type of star in the universe.""",
			'gradient' : preload("res://entities/star/gradients/t1.tres")
		},
		'interpolated_metadata' : {
			'temperature' : 1500,
			'luminosity' : 0.01, # 1/100th
			'mass' : 0.05,
			'scale' : 1.5,
		},
		'corona' : {
			'color': Vector3( 1.5 , 0.0 , 0.0 ),
			'timeFactor' : 0.218,
			'flareAmount' : 17,
			'size' : 4.3,
			'spiky' : 46.3,
			'gas' : 0.7
		},
		'star_body' : {
			'rotationSpeed' : 0.2,
			'cellSize' : 5.0,
			'wormCellSize' : 2.0,
			'vorCellSize' : 1.2,
			'convectionSpeed' : 0.1,
			'stretchFactor' : 1.188,
			'flowFactor' : 0.43
		}
	},
	Constants.Tiers.TIER_2 : {
		'state_thresholds' : {
			'threshold' : 10000,
			'min_flow_tolerance' : 30,
			'max_flow_tolerance' : 30
		},
		'metadata' : {
			'star_class' : "Orange Dwarf",
			'description' : """""",
			'gradient' : preload("res://entities/star/gradients/t1.tres")
		},
		'interpolated_metadata' : {
			'temperature' : 1500,
			'luminosity' : 0.0001, # 1/10,000th of the sun
			'mass' : 0.01,
			'scale' : 1.0,
		},
		'corona' : {

		},
		'star_body' : {

		}
	},
	Constants.Tiers.TIER_3 : {
		'state_thresholds' : {
			'threshold' : 50000,
			'min_flow_tolerance' : 20,
			'max_flow_tolerance' : 20
		},
		'metadata' : {
			'star_class' : "Yellow Dwarf",
			'description' : """""",
			'gradient' : preload("res://entities/star/gradients/t1.tres")
		},
		'interpolated_metadata' : {
			'temperature' : 1500,
			'luminosity' : 0.0001, # 1/10,000th of the sun
			'mass' : 0.01,
			'scale' : 1.5,
		},
		'corona' : {},
		'star_body' : {}
	}
}

# Extract the gradient into raw numbers.
# VERY BRITTLE! All Gradients MUST have 5 colors, no more, no less.
# Nessecary because godot tweens using shaders are extremely clunky.
static func _extract_gradient( gradient : Gradient ):
	var colors = []
	var offsets = []

	for i in range( 0 , gradient.colors.size() ):
		var thisColor = gradient.get_color( i )
		colors.append( Vector3( thisColor.r, thisColor.g , thisColor.b ) )
		offsets.append( gradient.get_offset( i ) )

	return {
		'colors' : colors,
		'offsets' : offsets
	}

static func get_tier_state(tier : int) -> Dictionary:
	var this_tier = TIER_STATES[tier].duplicate( true )
	this_tier['gradient'] = _extract_gradient( this_tier.metadata.gradient )

	return this_tier

static func get_tier_threshold( tier : int ) -> float:
	return TIER_STATES[tier].state_thresholds.threshold


static func get_tier_state_thresholds( tier : int ) -> Dictionary:
	return TIER_STATES[tier].state_thresholds


static func calculate_target_flow(current_hydrogen: int, star_tier: int) -> int:
	var func_value = 0
	var x: int = current_hydrogen

	match star_tier:
		Constants.Tiers.TIER_0:
			func_value = sqrt(x) + 50
		Constants.Tiers.TIER_1:
			func_value = sin(x) * 100
		# TODO: Fill in other tiers

	return int(func_value)


static func get_tier_percent_diff( current : float, s_tier : int , t_tier : int ):
	var s_tier_num = TIER_STATES[s_tier].state_thresholds.threshold
	var t_tier_num = TIER_STATES[t_tier].state_thresholds.threshold

	# Calculate percent diff between s_tier and t_tier, at current
	if( float( current ) <= float(s_tier_num) || float( current ) == 0.0 ):
		return 0.0
	
	# Calculate percentage of diff between the two values
	var total_diff = t_tier_num - s_tier_num
	var current_diff = current - s_tier_num
	var percent_diff = current_diff / total_diff

	return percent_diff

# Note this only for interpolated data. The rest is handled manually.
static func get_blank_tier_data() -> Dictionary:
	var new_state = {
		'interpolated_metadata' : {
			'temperature' : 1500,
			'luminosity' : 0.0001, # 1/10,000th of the sun
			'mass' : 0.01,
			'scale' : 0.5,
		},
		'corona' : {
			'color': null,
			'timeFactor' : null,
			'flareAmount' : null,
			'size' : null,
			'spiky' : null,
			'gas' : null
		},
		'star_body' : {
			'rotationSpeed' : null,
			'cellSize' : null,
			'wormCellSize' : null,
			'vorCellSize' : null,
			'convectionSpeed' :  null,
			'stretchFactor' : null,
			'flowFactor' :  null
		},
		'gradient' : {
			'colors' : [],
			'offsets' : [],
		}
	}
	
	return new_state
