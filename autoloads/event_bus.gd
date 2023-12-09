extends Node


# Building signals
signal construction_started(building)
signal constructed(building)


# Planet signals
signal planet_empty(planet)


# Event signals
signal event_happened(event_type)
signal event_started(event_type)
signal event_ended(event_type)


# Star signals
signal star_transitioned


# Misc. game signals
signal game_paused
signal game_unpaused
