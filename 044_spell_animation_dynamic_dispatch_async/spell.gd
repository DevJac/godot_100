@abstract
class_name Spell
extends RefCounted

signal _animation_finished

var _in_flight: int = 0

func wait_for_animations_to_finish() -> void:
	assert(_in_flight >= 0)
	while _in_flight != 0:
		await _animation_finished

func play_animations(main: Main) -> void:
	self._in_flight += 1
	@warning_ignore('redundant_await')
	await self._play_animations(main)
	self._in_flight -= 1
	assert(_in_flight >= 0)
	_animation_finished.emit()

@abstract
func _play_animations(main: Main) -> void;
