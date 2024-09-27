extends Label


func _process(_delta: float) -> void:
	var mouse_pressed: bool = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	var recent_events: bool = \
		(Time.get_ticks_msec() - $'../ColorRect'.last_gui_event) < 500
	text = 'Left mouse button pressed? %s\n\
		ColorRect received _gui_input events in last 0.5 seconds? %s'\
		% [mouse_pressed, recent_events]
