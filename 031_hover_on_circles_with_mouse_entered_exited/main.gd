extends Node2D


func point_query(p: Vector2) -> PhysicsPointQueryParameters2D:
	var q := PhysicsPointQueryParameters2D.new()
	q.collide_with_areas = true
	q.collide_with_bodies = false
	q.position = p
	return q


# Instead of _process, we could put this logic in _input
func _process(_delta: float) -> void:
	var on_top := true
	for i in range(get_child_count() - 1, -1, -1):
		var c := get_child(i)
		if on_top and c.mouse_inside:
			on_top = false
			c.find_child('Sprite2D').scale = Vector2.ONE * 1.15
		else:
			c.find_child('Sprite2D').scale = Vector2.ONE
