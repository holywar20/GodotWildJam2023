extends Node2D


func _ready() -> void:
	EventBus.connect("planet_nav_button_pressed", Callable(self, "_on_EB_planet_nav_button_pressed"))
	#AudioManager.play_music(AudioManager.MUSIC_TRACK_GAME_1)

func _on_EB_planet_nav_button_pressed(planetRef):
	$Camera2D.set_position(planetRef.get_position()-Vector2(-300,0))
