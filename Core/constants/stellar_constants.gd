extends Resource
class_name StellarConstants

const TEIR_STATES = {
    Constants.Teirs.TEIR_0 : {
        'metadata' : {
            'star_class' : "Brown Dwarf",
            'description' : """This star is a brown dwarf. It is not a star at all but rather on the boundary between planet and star. While still warm from its formation, it lacks the proper mass to ignite fusion on its own.

It is up to you to light this star, and bring illumination to a universe that is now dying to the pitiless cruelty of heat death.
""",
            'temperature' : 1500,
            'luminosity' : 0.0001, # 1/10,000th of the sun
            'mass' : 0.01,
        },
        'corona' : {
            
        },
        'star' : {
            
        }
    },
    Constants.Teirs.TIER_1 : {
        'metadata' : {
            'star_class' : "Red Dwarf",
            'description' : """This star is a red dwarf. It is a small, cool star that is very common in the universe. It is not very luminous, but it is very long lived. It is the most common type of star in the universe."""
            'temperature' : 3000,
            'luminosity' : 0.001, # 1 / 1000th of the sun
            'mass' : 0.08
        },
        'corona' : {},
        'star' : {}
    },
    Constants.Teirs.TIER_2 : {
        'metadata' : {
            'star_class' : "Orange Dwarf",
            'description' : """"""
            'temperature' : 4500,
            'luminosity' : 0.1, # 1/2 the sun
            'mass' : 0.5
        },
        'corona' : {

        },
        'star' : {

        }
    },
    Constants.Teirs.TIER_3 : {
        'metadata' : {
            'star_class' : "Yellow Dwarf",
            'description' : """"""
            'temperature' : 6000,
            'luminosity' : 0.1, # 1/2 the sun
            'mass' : 1
        },
        'corona' : {},
        'star' : {}
    }
}

static func get_teir_state(teir : int) -> Dictionary:
    return TEIR_STATES[teir]