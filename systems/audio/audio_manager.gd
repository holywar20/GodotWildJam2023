extends Node2D


@onready var music_player: AudioStreamPlayer2D = $Music/MusicPlayer
@onready var sfx_player_1: AudioStreamPlayer2D = $SFX/SFXPlayer1
@onready var sfx_player_2: AudioStreamPlayer2D = $SFX/SFXPlayer2
@onready var sfx_player_3: AudioStreamPlayer2D = $SFX/SFXPlayer3
@onready var sfx_player_4: AudioStreamPlayer2D = $SFX/SFXPlayer4

var music_tracks = {
	#"": preload("")
}

var sfx_tracks = {
	#"": preload("")
}

var _sfx_players = [
	sfx_player_1,
	sfx_player_2,
	sfx_player_3,
	sfx_player_4
]


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


func _play_stream(player: AudioStreamPlayer2D, stream: AudioStream) -> void:
	player.set_stream(stream)
	player.stream_paused = false
	player.play()
