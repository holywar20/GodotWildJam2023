extends Node2D


const MUSIC_TRACK_TITLE = "title"
const MUSIC_TRACK_GAME_1 = "game_1"
const MUSIC_TRACK_GAME_2 = "game_2"
const MUSIC_TRACK_GAME_3 = "game_3"
const MUSIC_TRACK_GAME_4 = "game_4"
const MUSIC_TRACK_GAME_5 = "game_5"
const MUSIC_TRACK_GAME_6 = "game_6"
const MUSIC_TRACK_GAME_7 = "game_7"


@onready var music_player: AudioStreamPlayer = $Music/MusicPlayer
@onready var sfx_player_1: AudioStreamPlayer = $SFX/SFXPlayer1
@onready var sfx_player_2: AudioStreamPlayer = $SFX/SFXPlayer2
@onready var sfx_player_3: AudioStreamPlayer = $SFX/SFXPlayer3
@onready var sfx_player_4: AudioStreamPlayer = $SFX/SFXPlayer4

var music_tracks = {
	MUSIC_TRACK_TITLE: preload("res://Assets/music/main_track.mp3"),
	MUSIC_TRACK_GAME_1: preload("res://Assets/music/MARiAN - Creative Technology.mp3"),
	MUSIC_TRACK_GAME_2: preload("res://Assets/music/MARiAN - Futuristic World.mp3"),
	MUSIC_TRACK_GAME_3: preload("res://Assets/music/MARiAN - Pandemic.mp3"),
	MUSIC_TRACK_GAME_4: preload("res://Assets/music/MARiAN - Retro Sci Fi.mp3"),
	MUSIC_TRACK_GAME_5: preload("res://Assets/music/MARiAN - Supernova.mp3"),
	MUSIC_TRACK_GAME_6: preload("res://Assets/music/MARiAN - Retro Sci Fi.mp3"),
	MUSIC_TRACK_GAME_7: preload("res://Assets/music/The Space.mp3")
}

var sfx_tracks = {
	'DANGER_WARNING' : preload("res://Assets/sounds/warning.wav"),
	'HOVER_BUTTON' : preload("res://Assets/sounds/Hover.wav")
}

@onready var _sfx_players = [
	$SFX/SFXPlayer1,
	$SFX/SFXPlayer2,
	$SFX/SFXPlayer3,
	$SFX/SFXPlayer4
]


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func play_music(track: String) -> void:
	_play_stream(music_player, music_tracks[track])


func play_sfx(track: String) -> void:
	var players_checked_count: int = 0

	for player in _sfx_players:
		if player.is_playing():
			players_checked_count += 1
			continue

		_play_stream(player, sfx_tracks[track])
		break

	if players_checked_count == _sfx_players.size():
		_play_stream(_sfx_players[0], sfx_tracks[track])


func _play_stream(player: AudioStreamPlayer, stream: AudioStream) -> void:
	player.set_stream(stream)
	player.stream_paused = false
	player.play()
