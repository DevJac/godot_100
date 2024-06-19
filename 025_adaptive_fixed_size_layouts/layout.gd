extends Control


func take_squares() -> Array[ColorRect]:
	var squares := [
		$ColorRect1,
		$ColorRect2,
		$ColorRect3,
	]
	for s: ColorRect in squares:
		prints(s.global_position)
		remove_child(s)
	assert(squares.size() == 3)
	var result: Array[ColorRect] = []
	result.assign(squares)
	return result


func set_squares(new_squares: Array[ColorRect]) -> void:
	assert(new_squares.size() == 3)
	for new_square_i: int in new_squares.size():
		var new_square: ColorRect = new_squares[new_square_i]
		prints(new_square.global_position, new_square.position)
		var old_square: ColorRect = get_child(new_square_i)
		var tween = create_tween()
		tween.tween_property(
			new_square,
			'position',
			old_square.position,
			2)
		remove_child(old_square)
		old_square.free()
		new_square.owner = null
		add_child(new_square)
		new_square.owner = self
		move_child(new_square, new_square_i)
