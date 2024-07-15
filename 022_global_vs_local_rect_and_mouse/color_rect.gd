extends ColorRect


func _process(_delta: float) -> void:
	$LocalDebugLabel.text = (
		'Local Rect: %20s  Local Mouse Position: %20s  Contains Mouse: %6s' %
		[
			get_rect(),
			get_local_mouse_position() + get_rect().position,
			get_rect().has_point(get_local_mouse_position() + get_rect().position),
		])
	$GlobalDebugLabel.text = (
		'Global Rect: %20s  Global Mouse Position: %12s  Contains Mouse: %6s' %
		[
			get_global_rect(),
			get_global_mouse_position(),
			get_global_rect().has_point(get_global_mouse_position()),
		])
	color = Color(1, 1, 1)
	if get_rect().has_point(get_local_mouse_position() + get_rect().position):
		color.r -= 1
	if get_global_rect().has_point(get_global_mouse_position()):
		color.g -= 1
