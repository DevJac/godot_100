class_name PlaySoundButton
extends Button

signal play_sound(sound: AudioStream)

@export var sound: AudioStream

func _pressed() -> void:
	play_sound.emit(sound)
