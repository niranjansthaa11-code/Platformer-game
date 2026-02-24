extends Node2D 

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
var is_muted: bool = false

func _ready():
	play_music()

func play_music():
	if not audio_player.playing:
		audio_player.play()

func stop_music():
	audio_player.stop()

func change_track(new_audio_stream: AudioStream):
	audio_player.stream = new_audio_stream
	audio_player.play()
func set_paused(should_pause: bool):
	if audio_player:
		audio_player.stream_paused = should_pause
func toggle_mute():
	is_muted = !is_muted
	# 0 is the index of the "Master" audio bus
	AudioServer.set_bus_mute(0, is_muted)
