extends ColorRect


func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(self, 'position', position + Vector2(100, 0), 2)
	tween.tween_property(self, 'color', Color.RED, 2)
