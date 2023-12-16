extends Resource
class_name StellarConstants

const TIER_STATES = {
	Constants.Tiers.TIER_0 : {
		'state_thresholds' : {
			'threshold' : 0,
			'min_flow_tolerance' : 50,
			'max_flow_tolerance' : 50
		},
		'metadata' : {
			'star_class' : "Brown Dwarf",
			'description' : """This dim star is a brown dwarf. It is not a star at all but rather on the boundary between planet and star. While still warm from its formation, it lacks the proper mass to ignite fusion on its own.

	It is up to you to light this star, and bring illumination to a universe that is now dying to the pitiless cruelty of heat death.
	
	You will start with some Power and Base Metals to get you going, but use them wisely.
	""",
			'gradient' : preload("res://entities/star/gradients/t0.tres")
		},
		'interpolated_metadata' : {
			'temperature' : 1500,
			'luminosity' : 0.0001, # 1/10,000th of the sun
			'mass' : 0.01,
			'scale' : 0.1,
		},
		'corona' : {
			'color': Vector3( 0.69 , 0.0 , 0.875 ),
			'colorBalance' : 0.1,
			'timeFactor' : 0.09,
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
			'description' : """Thanks to your efforts, the star is now a red dwarf.
			
			It is a small, cool star that is very common in the universe. It is not very luminous, but it is very long lived. It is the most common type of star in the universe.
			
			More planets are now available for you to explore.""",
			'gradient' : preload("res://entities/star/gradients/t1.tres")
		},
		'interpolated_metadata' : {
			'temperature' : 1500,
			'luminosity' : 0.01, # 1/100th
			'mass' : 0.05,
			'scale' : 0.5,
		},
		'corona' : {
			'color': Vector3( 1.5 , 0.0 , 0.0 ),
			'colorBalance' : 0.25,
			'timeFactor' : 0.218,
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
			'description' : """From a red dwarf, the star has become a glowing orange dwarf.
			
			More planets are also now available for you to explore.
			
			Stable and possibly capable of helping support life, this ball of gas continues to devour fuel like a growing adolescent. It isn't an adult yet, but 
			it will be with your continued help.
			
			Just be sure to keep an eye on your new teenager.""",
			'gradient' : preload("res://entities/star/gradients/t2.tres")
		},
		'interpolated_metadata' : {
			'temperature' : 4500,
			'luminosity' : 0.5,
			'mass' : 0.5,
			'scale' : 1.0,
		},
		'corona' : {
			'color': Vector3(1.502 , 0.483, 0.0 ),
			'colorBalance' : 0.4,
			'timeFactor' : 0.26,
			'size' : 3.1,
			'spiky' : 10.6,
			'gas' : 2.2
		},
		'star_body' : {
			'rotationSpeed' : 0.25,
			'cellSize' : 5.9,
			'wormCellSize' : 2.8,
			'vorCellSize' : 2.0,
			'convectionSpeed' : 0.65,
			'stretchFactor' : 1.165,
			'flowFactor' : 0.25
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
			'description' : """Another Sol has emerged from what was once a cold, dead celestial body.
			
			The star's voracious appetite has only accelerated, although its warmth and luminosity make the possibility of life on orbiting planet a very distinct 
			posibility.
			
			Will your new sun be the saving grace of the universe? Or will it run amok, greedily fusing anything it can get its hands on until it becomes too big to support itself?""",
			'gradient' : preload("res://entities/star/gradients/t3.tres")
		},
		'interpolated_metadata' : {
			'temperature' : 6000,
			'luminosity' : 1.0, # 1/10,000th of the sun
			'mass' : 1.0,
			'scale' : 1.5,
		},
		'corona' : {
			'color': Vector3( 1.502 , 1.0 , 0 ),
			'colorBalance' : 0.605,
			'timeFactor' : 0.17,
			'size' : 3.8,
			'spiky' : 50,
			'gas' : 0.6
		},
		'star_body' : {
			'rotationSpeed' : 0.348,
			'cellSize' : 5.0,
			'wormCellSize' : 2.4,
			'vorCellSize' : 2.5,
			'convectionSpeed' : 0.8,
			'stretchFactor' : 1.398,
			'flowFactor' : 0.39
		}
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

static func get_threshold( tier : int ) -> float:
	return TIER_STATES[tier].state_thresholds.threshold

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
	if( float( current ) <= float( s_tier_num ) || float( current ) == 0.0 ):
		return 0.0
	
	# Calculate percentage of diff between the two values
	var total_diff = t_tier_num - s_tier_num
	var current_diff = current - s_tier_num
	var percent_diff = current_diff / total_diff

	return percent_diff

static func get_tier_metadata(tier: int) -> Dictionary:
	return TIER_STATES[tier].metadata

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
