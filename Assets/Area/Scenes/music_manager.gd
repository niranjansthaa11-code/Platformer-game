extends Node2D 

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

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
