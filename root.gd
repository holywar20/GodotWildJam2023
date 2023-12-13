extends Node2D


func _ready() -> void:
	EventBus.connect("planet_nav_button_pressed", Callable(self, "_on_EB_planet_nav_button_pressed"))
	EventBus.connect("return_to_star_pressed", Callable(self, "_on_EB_return_to_star_pressed"))
	#AudioManager.play_music(AudioManager.MUSIC_TRACK_GAME_1)

func _on_EB_planet_nav_button_pressed(planetRef):
	var moveTween = create_tween()
	moveTween.tween_property($Camera2D,'position',planetRef.get_position()-Vector2(-300,0),2.0)
	moveTween.play()
	#$Camera2D.set_position(planetRef.get_position()-Vector2(-300,0))

func _on_EB_return_to_star_pressed():
	var moveTween = create_tween()
	moveTween.tween_property($Camera2D,'position',Vector2(0,0),2.0)
	moveTween.play()
	#$Camera2D.set_position(Vector2(0,0))
