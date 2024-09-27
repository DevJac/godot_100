extends ColorRect


var last_gui_event: int = 0
var mouse_pressed: bool = false


func _ready() -> void:
	$ClickLabel.visible = false


func _process(_delta: float) -> void:
	if Time.get_ticks_msec() - last_gui_event > 500:
		color = Color.WHITE
	assert(not has_focus())


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			mouse_pressed = true
		elif mouse_pressed and not event.pressed:
			if Rect2(Vector2.ZERO, size).has_point(event.position):
				# This is the "on mouse up" scenerio basically.
				# The mouse was pressed while in the Control, and is now
				# released while in the Control. We have to double check that
				# the mouse is inside the Control because Controls continue
				# to receive gui_input events even if the mouse is outside the
				# Control if the mouse button is held down.
				$ClickLabel.visible = true
				var timer = Timer.new()
				timer.one_shot = true
				timer.autostart = true
				timer.wait_time = 2
				timer.timeout.connect(func():
					$ClickLabel.visible = false)
				add_child(timer)
	last_gui_event = Time.get_ticks_msec()
	prints(last_gui_event, event)
	color = Color.RED
