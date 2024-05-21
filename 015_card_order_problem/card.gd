class_name Card
extends Sprite2D


var grabbed := false
var grab_offset := Vector2.ZERO
var number: int = 0


func _on_control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		grabbed = event.pressed and event.button_mask == MOUSE_BUTTON_MASK_LEFT
		if grabbed:
			grab_offset = event.global_position - self.global_position
	if event is InputEventMouseMotion:
		if grabbed:
			self.global_position = event.global_position - self.grab_offset


func _on_control_mouse_entered() -> void:
	self.scale = Vector2.ONE * 1.2


func _on_control_mouse_exited() -> void:
	if not grabbed:
		self.scale = Vector2.ONE
