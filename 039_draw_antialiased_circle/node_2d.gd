extends Node2D


var aa: bool = false


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			aa = not aa
			queue_redraw()


func _draw() -> void:
	var width := {false: 15, true: 14}
	draw_circle(Vector2(90, 100), 50, Color.WHITE, false, width[aa], aa)
	draw_circle(Vector2(230, 100), 50, Color.WHITE, false, width[not aa], not aa)
