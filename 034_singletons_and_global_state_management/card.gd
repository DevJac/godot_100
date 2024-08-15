extends ColorRect


func _on_mouse_entered() -> void:
	color = %ColorOption.color
	HoverCount.hover_count += 1


func _on_mouse_exited() -> void:
	color = Color.WHITE
