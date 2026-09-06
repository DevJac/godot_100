extends VBoxContainer

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
var playback: AudioStreamPlaybackPolyphonic

func _ready() -> void:
	audio_player.play()
	playback = audio_player.get_stream_playback()
	assert(playback != null)

	for child in get_children():
		if child is PlaySoundButton:
			var button: PlaySoundButton = child
			button.play_sound.connect(_on_play_sound_pressed)

func _on_play_sound_pressed(sound: AudioStream) -> void:
	playback.play_stream(sound)
