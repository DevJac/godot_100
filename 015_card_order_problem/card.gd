class_name Card
extends Sprite2D


var grabbed := false
var grab_offset := Vector2.ZERO
var hovered := false
var index: int = 0


func _on_control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		grabbed = event.pressed and event.button_mask == MOUSE_BUTTON_MASK_LEFT
		if grabbed:
			grab_offset = event.global_position - self.global_position
	if event is InputEventMouseMotion:
		if grabbed:
			self.global_position = event.global_position - self.grab_offset


func _process(_delta: float) -> void:
	# The following line can only unset hovered.
	# It's an extra check for when a card moves, because moving a node will
	# not trigger the mouse_existed signal.
	hovered = hovered and get_rect().has_point(get_local_mouse_position())
	if grabbed or hovered:
		scale = Vector2.ONE * 1.1
	else:
		scale = Vector2.ONE


func _on_control_mouse_entered() -> void:
	hovered = true


func _on_control_mouse_exited() -> void:
	hovered = false
