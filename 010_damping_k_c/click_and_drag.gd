extends Control


var grabbed := false
var grab_offset := Vector2.ZERO
var initial_global_position := Vector2.ZERO
var target_global_position := Vector2.ZERO
var velocity := Vector2.ZERO


func _gui_input(event):
	if event is InputEventMouseButton:
		grabbed = event.pressed and event.button_mask == MOUSE_BUTTON_MASK_LEFT
		if grabbed:
			grab_offset = event.global_position - self.global_position
			get_parent().move_child(self, -1)
	if event is InputEventMouseMotion:
		if grabbed:
			target_global_position = event.global_position - grab_offset


func _ready():
	initial_global_position = global_position
	target_global_position = global_position
	var button: Button = get_parent().get_node('Button')
	button.pressed.connect(_on_button_pressed)


func _process(delta):
	# See: https://en.wikipedia.org/wiki/Damping
	# Spring Constant (k) controls how forcefully node moves towards target.
	# This controls the overall speed of the motion and damping physics.
	var k := 500.0
	# Damping Coefficient (c) controls how quickly the node slows down and
	# loses energy. c = 2 * sqrt(k) is critical damping, which results in
	# maximum acceleration and speed without oscillating.
	var c := 2 * sqrt(k) * 0.5
	var to_target := target_global_position - global_position
	var acceleration := k * to_target - c * velocity
	velocity += acceleration * delta
	global_position += velocity * delta


func _on_button_pressed():
	target_global_position = initial_global_position
