extends ColorRect


static var color_names = {
	Color(1, 1, 1, 1): 'White',
	Color(1, 0, 0, 1): 'Red',
}


func _ready() -> void:
	$Area2D.connect(
		'mouse_entered',
		func():
			prints('mouse entered', color_names[color])
			scale = Vector2.ONE * 1.2
	)
	$Area2D.connect(
		'mouse_exited',
		func():
			prints('mouse exited', color_names[color])
			scale = Vector2.ONE
	)
