extends Control


var n_corrections_init = Vector2(1e-8, 1e-8)
var n_corrections = Vector2(n_corrections_init)


func _gui_input(event):
	if event is InputEventMouseMotion:
		if event.button_mask & MOUSE_BUTTON_MASK_LEFT:
			position += event.relative


func _process(delta):
	var bounds_correction = Vector2(0, 0)
	if position.x < 0:
		bounds_correction.x = 0 - position.x
		n_corrections.x += 1
	if position.y < 0:
		bounds_correction.y = 0 - position.y
		n_corrections.y += 1
	if get_rect().end.x > get_parent().get_rect().end.x:
		bounds_correction.x += get_parent().get_rect().end.x - get_rect().end.x
		n_corrections.x += 1
	if get_rect().end.y > get_parent().get_rect().end.y:
		bounds_correction.y += get_parent().get_rect().end.y - get_rect().end.y
		n_corrections.y += 1
	position += bounds_correction / n_corrections
	var alpha = 2**(-delta / 0.005)
	n_corrections = alpha * n_corrections + (1 - alpha) * n_corrections_init
