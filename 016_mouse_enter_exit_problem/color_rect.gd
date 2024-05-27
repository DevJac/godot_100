extends ColorRect


func _ready() -> void:
	var timer := Timer.new()
	timer.wait_time = 2
	timer.autostart = true
	timer.connect(
		'timeout',
		func move():
			if position == Vector2(192, 192):
				position = Vector2(576, 192)
			elif position == Vector2(576, 192):
				position = Vector2(192, 192)
	)
	add_child(timer)


func _on_mouse_entered() -> void:
	color = Color.RED


func _on_mouse_exited() -> void:
	color = Color.WHITE
