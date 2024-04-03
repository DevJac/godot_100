extends Control


var target_position: Vector2 = Vector2.ZERO
var grab_offset: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO
var smoothTime = 0.02


func clamp_target_position_to_screen():
	var valid_positions = get_parent().get_rect()
	valid_positions.end -= size
	for correction_iteration in range(1, 3):
		var correction = Vector2.ZERO
		if target_position.x < valid_positions.position.x:
			correction.x += valid_positions.position.x - target_position.x
		if target_position.y < valid_positions.position.y:
			correction.y += valid_positions.position.y - target_position.y
		if target_position.x > valid_positions.end.x:
			correction.x += valid_positions.end.x - target_position.x
		if target_position.y > valid_positions.end.y:
			correction.y += valid_positions.end.y - target_position.y
		target_position += correction / correction_iteration


func _gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			grab_offset = event.position
			smoothTime = 1.0 / 20
		else:
			smoothTime = 1.0 / 5
	if event is InputEventMouseMotion:
		if event.button_mask & MOUSE_BUTTON_MASK_LEFT:
			target_position = event.global_position - grab_offset
			clamp_target_position_to_screen()


func _process(deltaT):
	# See Game Programming Gems 4, page 95, for explanation of these formulas
	var pd = target_position
	var p0 = global_position
	var v = velocity
	var omega = 2.0 / smoothTime
	var e = exp(-omega * deltaT)
	global_position = pd + ((p0 - pd) + (v + omega * (p0 - pd)) * deltaT) * e
	velocity = (v - (v + omega * (p0 - pd)) * omega * deltaT) * e


func _on_control_resized():
	clamp_target_position_to_screen()


func _on_button_pressed():
	target_position = Vector2.ZERO
