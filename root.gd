extends Node2D


@onready var _clouds: Node2D = $SolarSystem/Clouds


func _ready() -> void:
	#get_tree().paused = true
	EventBus.connect("planet_nav_button_pressed", Callable(self, "_on_EB_planet_nav_button_pressed"))
	EventBus.connect("return_to_star_pressed", Callable(self, "_on_EB_return_to_star_pressed"))
	EventBus.new_game.connect(_on_new_game)
	EventBus.magnetic_bore_constructed.connect(_on_magnetic_bore_constructed)
	#AudioManager.play_music(AudioManager.MUSIC_TRACK_TITLE)

func _on_EB_planet_nav_button_pressed(planetRef):
	var moveTween = create_tween()
	moveTween.finished.connect(_on_tween_finished)
	moveTween.tween_property($Camera2D,'position', planetRef.get_position() - Vector2(-300, 0), 1.0)
	moveTween.play()

func _on_tween_finished() -> void:
	EventBus.camera_move_to_planet_finished.emit()

func _on_EB_return_to_star_pressed():
	var moveTween = create_tween()
	moveTween.tween_property($Camera2D,'position', Vector2(0, 0), 1.0)
	moveTween.play()


func _on_new_game() -> void:
	#AudioManager.play_music(AudioManager.MUSIC_TRACK_GAME_1)
	EventBus.game_unpaused.emit()


func _on_magnetic_bore_constructed(building) -> void:
	building.set_gas_clouds(_clouds.get_children())
