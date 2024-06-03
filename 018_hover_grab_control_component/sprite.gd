extends Sprite2D


func _on_hover_grab_control_hover_begin() -> void:
	scale = Vector2.ONE * 1.2


func _on_hover_grab_control_hover_end() -> void:
	scale = Vector2.ONE


func _on_hover_grab_control_grab_begin() -> void:
	prints('drag begin')


func _on_hover_grab_control_grab_end(drag_stats: DragStats) -> void:
	prints('drag end', drag_stats.drag_position, drag_stats.drag_relative, drag_stats.drag_cumulative)
	if drag_stats.drag_cumulative.length_squared() < 100:
		prints('==== clicked ====')


func _on_hover_grab_control_drag(
			_mouse_motion: InputEventMouseMotion,
			drag_stats: DragStats
		) -> void:
	global_position = drag_stats.drag_position
