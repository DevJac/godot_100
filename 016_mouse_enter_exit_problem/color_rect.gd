extends ColorRect


func _ready() -> void:
	var timer := Timer.new()
	timer.wait_time = 2
	timer.autostart = true
	timer.connect(
		'timeout',
		func move():
			if position == Vector2(192, 192):
				move_then_set_color(Vector2(576, 192))
			elif position == Vector2(576, 192):
				move_then_set_color(Vector2(192, 192))

	)
	add_child(timer)


func move_then_set_color(new_position: Vector2):
	position = new_position
	if get_global_rect().has_point(get_global_mouse_position()):
		_on_mouse_entered()
	else:
		_on_mouse_exited()


func _on_mouse_entered() -> void:
	color = Color.RED


func _on_mouse_exited() -> void:
	color = Color.WHITE
