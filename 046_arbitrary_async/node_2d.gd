extends Node2D

# This is an example of asyncronous coroutines.
# You can invoke them asyncronously without using the await keyword.
# You can add arbitrary logic to handle their return value and wait for some
# or none of them to return.

# It shows how completely arbitrary logic can be implemented.
# Although, this is all implemented in a rather unsophisticated way.

var returned: Array[String] = []
var stop_foo_early: bool = false

signal end

func _ready() -> void:
	foo('_')
	foo('_')
	foo('_')
	foo('_')
	foo('_')
	
	end.connect(print_end)

	@warning_ignore('shadowed_variable_base_class')
	(func(name: String) -> void:
		var answer = await foo(name)
		if stop_foo_early:
			return
		print('the answer is: %s' % answer)
		returned.push_back(name)
		if end_condition_met():
			stop_foo_early = true
			end.emit()
	).call('a')
	@warning_ignore('shadowed_variable_base_class')
	(func(name: String) -> void:
		await foo(name)
		if stop_foo_early:
			return
		returned.push_back(name)
		if end_condition_met():
			stop_foo_early = true
			end.emit()
	).call('b')
	@warning_ignore('shadowed_variable_base_class')
	(func(name: String) -> void:
		await foo(name)
		if stop_foo_early:
			return
		returned.push_back(name)
		if end_condition_met():
			stop_foo_early = true
			end.emit()
	).call('c')
	@warning_ignore('shadowed_variable_base_class')
	(func(name: String) -> void:
		await foo(name)
		if stop_foo_early:
			return
		returned.push_back(name)
		if end_condition_met():
			stop_foo_early = true
			end.emit()
	).call('d')
	
	await get_tree().create_timer(3).timeout
	print('actual end: %s' % str(returned))

func end_condition_met() -> bool:
	var a_plus_one_other: bool = 'a' in returned and returned.size() >= 2
	var d: bool = 'd' in returned
	return a_plus_one_other or d

func print_end():
	print('end: we got a + 1 other or d: %s' % str(returned))

@warning_ignore('shadowed_variable_base_class')
func foo(name: String) -> int:
	await get_tree().create_timer(randf_range(0, 3)).timeout
	if stop_foo_early:
		return -1
	print('foo returning: %s' % name)
	return 42
