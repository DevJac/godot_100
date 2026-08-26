class_name Main
extends Node

const Fire: GDScript = preload('res://fire.gd')
const Ice: GDScript = preload('res://ice.gd')

func _ready() -> void:
	pprint('_ready begin')
	var joiner: Joiner = Joiner.new()
	pprint('==== ice animation x1')
	var ice: Spell = Ice.new()
	joiner.track(ice.play_animations.bind(self))
	await joiner.join()
	pprint('==== fire animation x3')
	var fire: Spell = Fire.new()
	joiner.track(fire.play_animations.bind(self))
	joiner.track(fire.play_animations.bind(self))
	joiner.track(fire.play_animations.bind(self))
	await joiner.join()
	pprint('==== fire and ice, reused')
	joiner.track(fire.play_animations.bind(self))
	joiner.track(ice.play_animations.bind(self))
	await joiner.join()
	pprint('==== fire, but canceled')
	joiner.track(fire.play_animations.bind(self))
	@warning_ignore('missing_await')
	joiner.join()
	fire = null # causes the coroutines owned by fire object to cease
	# fire animations 2 and 3 will never run
	# this does break the internal joiner state though; _in_flight will equal 1
	pprint('_ready end')
	await get_tree().create_timer(30).timeout
	pprint(joiner._in_flight)
	pprint('really done')

func pprint(msg: Variant) -> void:
	print('[%6d %8.3f] %s' % [
		Engine.get_process_frames(), Time.get_ticks_msec() / 1000.0, msg])


class Joiner extends RefCounted:

	signal _calls_finished

	var _in_flight: int = 0

	func track(f: Callable) -> void:
		assert(self._in_flight >= 0)
		self._in_flight += 1
		(func () -> void:
			await f.call()
			self._in_flight -= 1
			assert(self._in_flight >= 0)
			if self._in_flight <= 0:
				self._calls_finished.emit()
		).call()

	func join() -> void:
		while self._in_flight > 0:
			await _calls_finished
