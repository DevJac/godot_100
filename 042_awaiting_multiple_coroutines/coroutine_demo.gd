extends Node

func _ready() -> void:
	var cj := CoroutineJoiner.new()
	cj.add(do_something.bind(1))
	cj.add(do_something.bind(2))
	cj.add(do_something.bind(3))
	await cj.wait()
	pprint('did all the things')

func do_something(id: int) -> void:
	var duration := randf_range(0.5, 3.0)
	pprint('task %d starting, will take %.2fs' % [id, duration])
	await get_tree().create_timer(duration).timeout
	pprint('task %d done' % id)

func pprint(msg: Variant) -> void:
	print('[%7.3f] %s' % [Time.get_ticks_msec() / 1000.0, msg])


class CoroutineJoiner extends RefCounted:
	signal all_done
	var _remaining: int = 0
	func add(callable: Callable) -> void:
			_remaining += 1
			(func() -> void:
				await callable.call()
				_remaining -= 1
				if _remaining == 0:
					all_done.emit()
			).call()
	func wait() -> void:
		if _remaining > 0:
			await all_done
