extends ColorRect


func _ready() -> void:
	var tween_1 = create_tween()
	tween_1.tween_property(self, 'position', position + Vector2(100, 0), 2)
	var tween_2 = create_tween()
	tween_2.tween_property(self, 'color', Color.RED, 2)
