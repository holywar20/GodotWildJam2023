extends Node2D


@onready var _clouds: Node2D = $SolarSystem/Clouds
@onready var _ui = $UI
@onready var _solar_system = $SolarSystem

func _ready() -> void:
	_ui.hide()
	get_tree().paused = true
	EventBus.connect("planet_nav_button_pressed", Callable(self, "_on_EB_planet_nav_button_pressed"))
	EventBus.connect("return_to_star_pressed", Callable(self, "_on_EB_return_to_star_pressed"))
	EventBus.connect("danger_fail", Callable(self, "_on_EB_danger_fail"))
	EventBus.connect("game_restart", Callable(self, "_on_EB_game_restart"))
	
	EventBus.new_game.connect(_on_new_game)
	EventBus.constructed.connect(_on_constructed)
	AudioManager.play_music(AudioManager.MUSIC_TRACK_TITLE)

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
	AudioManager.play_music(AudioManager.MUSIC_TRACK_GAME_1)
	_ui.show()
	_solar_system.show()
	EventBus.game_unpaused.emit()

func _on_EB_game_restart():
	for planet in get_tree().get_nodes_in_group( "PLANET_SCENE" ):
		planet.reset_resources()

func _on_constructed(building) -> void:
	if building.type != Constants.BUILDING_MAGNETIC_BORE:
		return

	building.set_gas_clouds(_clouds.get_children())
