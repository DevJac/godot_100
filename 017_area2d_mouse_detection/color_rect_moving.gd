extends ColorRect


func _ready() -> void:
	$Area2D.connect(
		'mouse_entered',
		func():
			color = Color.BLUE
	)
	$Area2D.connect(
		'mouse_exited',
		func():
			color = Color.WHITE
	)
	var timer := Timer.new()
	timer.wait_time = 2
	timer.autostart = true
	timer.connect(
		'timeout',
		func move():
			if position == Vector2(640, 192):
				position = Vector2(896, 192)
			elif position == Vector2(896, 192):
				position = Vector2(640, 192)
	)
	add_child(timer)
