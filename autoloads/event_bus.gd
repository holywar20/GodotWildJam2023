extends Node


# Game time signals
signal tick()


# Building signals
signal construction_requested(building_type) # Fired by UI
signal construction_started(building) 
signal constructed( building )
signal dyson_construction_started()
signal dyson_construction_finished()
signal build_queue(buildings) # Array

# Resource signals
signal resources_extracted(resources) # Dictionary keyed by resource with amounts as values

# Planet signals
signal planet_empty( planet )
signal planet_cracker_vals_changed( val_array ) # Dictionary with 3 values

# Event/effect signals
signal adjust_hydrogen(amount) # can be positive or negative amount
signal adjust_dyson_swarm_output(amount) # can be positive or negative
signal disable_random_buildings(number)


# Star signals
signal star_transitioned( star_state ) # Fired by Star Scene
signal star_size_changed( star_metadata ) # Fired by Star Scene
signal star_hydrogen_updated(current_amount, target_amount)
signal star_hydrogen_target_updated(min_target, max_target)


# UI signals
signal resources_reported(resources) # Dictionary keyed by resource with amounts as values
signal camera_moved( camera_pos ) # Vector2
signal time_scale_updated(scale)


# Misc. game signals
signal game_paused
signal game_unpaused
