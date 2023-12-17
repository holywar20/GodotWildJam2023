extends Node


# Game time signals
signal tick()


# Building signals
signal construction_requested(building_type) # Fired by UI
signal construction_started(building) 
signal constructed( building )
signal destroyed( building )
signal dyson_construction_started()
signal dyson_construction_finished()
signal build_queue(buildings) # Array
signal operational_cost_reported(resources)


# Resource signals
signal resources_extracted(resources) # Dictionary keyed by resource with amounts as values
signal gas_cloud_hovering(gas_cloud)
signal gas_cloud_stop_hovering(gas_cloud)


# Planet signals
signal planet_empty( planet )
signal planet_depletion(planet)
signal planet_cracker_vals_changed( val_array ) # Dictionary with 3 values
signal planet_selected(planet)
signal zoom_changed( zoom_level )
signal camera_move_to_planet_finished()


# Event/effect signals
signal event_started(event)
signal event_concluded(event)
signal adjust_hydrogen(amount) # can be positive or negative amount
signal adjust_dyson_swarm_output(amount) # can be positive or negative
signal emp_wave_happened(percent_chance_to_disable)


# Star signals
signal star_transitioned( star_state ) # Fired by Star Scene
signal star_size_changed( star_metadata ) # Fired by Star Scene
signal hydrogen_flow_updated(actual_flow, ideal_target_flow, min_target_flow, max_target_flow)


signal danger_count( count ) # Fired by flow display. Lets you know when things are about to get bad.
signal danger_fail() # fired by flow display. You've exceeded the danger threshold and the star is going to explode.

# UI signals
signal resources_reported(resources) # Dictionary keyed by resource with amounts as values
signal camera_moved( camera_pos ) # Vector2
signal time_scale_updated(scale)
signal building_pressed(building)
signal planet_nav_button_pressed(planetRef)
signal return_to_star_pressed()
signal bore_control_updated(value)


# Misc. game signals
signal game_paused(show_pause_screen)
signal game_unpaused
signal new_game
signal feedback_message(message)
