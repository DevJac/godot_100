extends VBoxContainer

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
var playback: AudioStreamPlaybackPolyphonic

# AudioStreamPlayer plays AudioStreams, obviously.
# AudioStreams are more than just sounds, they can be sound generators.
# In this case, we start an AudioStreamPlayer and it keeps playing--
# it never stops playing.
# AudioStreamPolyphonic is what is continuously played.
# We get the "playback" and can use that to interact with the AudioStream.

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
