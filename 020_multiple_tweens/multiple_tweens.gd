extends ColorRect


func my_position() -> Vector2:
	prints('get position', position)
	return position


func _ready() -> void:
	var tween = create_tween()
	(tween
	.tween_property(self, 'position', my_position() + Vector2(100, 100), 4))
	(tween
	.parallel()
	.tween_property(self, 'position', my_position() + Vector2(100, -100), 2))

# You should avoid using more than one Tween per object's property. If two or more
# tweens animate one property at the same time, the last one created will take
# priority and assign the final value. If you want to interrupt and restart an
# animation, consider assigning the Tween to a variable.
