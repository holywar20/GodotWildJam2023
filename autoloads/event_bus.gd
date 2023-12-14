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
signal operational_cost(resources)


# Resource signals
signal resources_extracted(resources) # Dictionary keyed by resource with amounts as values


# Planet signals
signal planet_empty( planet )
signal planet_cracker_vals_changed( val_array ) # Dictionary with 3 values
signal planet_selected(planet)
signal camera_move_to_planet_finished()


# Event/effect signals
signal adjust_hydrogen(amount) # can be positive or negative amount
signal adjust_dyson_swarm_output(amount) # can be positive or negative
signal disable_random_buildings(number)


# Star signals
signal star_transitioned( star_state ) # Fired by Star Scene
signal star_size_changed( star_metadata ) # Fired by Star Scene
signal hydrogen_flow_updated(actual_flow, ideal_target_flow, min_target_flow, max_target_flow)


# UI signals
signal resources_reported(resources) # Dictionary keyed by resource with amounts as values
signal camera_moved( camera_pos ) # Vector2
signal time_scale_updated(scale)
signal building_pressed(building)
signal planet_nav_button_pressed(planetRef)
signal return_to_star_pressed()


# Misc. game signals
signal game_paused(show_pause_screen)
signal game_unpaused
signal new_game
signal feedback_message(message)
