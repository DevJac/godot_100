extends Node2D


func point_query(p: Vector2) -> PhysicsPointQueryParameters2D:
	var q := PhysicsPointQueryParameters2D.new()
	q.collide_with_areas = true
	q.collide_with_bodies = false
	q.position = p
	return q


# Instead of _process, we could put this logic in _input
func _process(_delta: float) -> void:
	var space_state := get_tree().root.world_2d.direct_space_state
	var ips := (
		space_state
		.intersect_point(point_query(get_global_mouse_position()))
		.map(func (ip): return ip.collider.get_parent()))
	ips.sort_custom(func (a, b):  return -a.get_index() < -b.get_index())
	for c in get_children():
		if ips and c == ips[0]:
			c.find_child('Sprite2D').scale = Vector2.ONE * 1.15
		else:
			c.find_child('Sprite2D').scale = Vector2.ONE
