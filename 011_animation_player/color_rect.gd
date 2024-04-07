extends ColorRect


func _gui_input(event):
	print(event)
	if event is InputEventMouseButton:
		if event.pressed and event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			print('Playing')
			$'../AnimationPlayer'.play('color_rect_position_animation')
