extends Node


# Building signals
signal construction_started(building) # Fired by UI
signal constructed( building )
signal cracker_construction_started( planet )
signal cracker_construction_finished( planet )
signal dyson_construction_started()
signal dyson_construction_finished()


# Planet signals
signal planet_empty( planet )
signal planet_cracker_vals_changed( val_array ) # Dictionary with 3 values

# Event signals
signal event_happened(event_type) # Constant ( or perhaps a full parameterized event )
signal event_started(event_type)
signal event_ended(event_type)


# Star signals
signal star_transitioned( star_state ) # Fired by Star Scene

# Misc. game signals
signal game_paused
signal game_unpaused
