extends Control


func point_query(p: Vector2) -> PhysicsPointQueryParameters2D:
	var q := PhysicsPointQueryParameters2D.new()
	q.collide_with_areas = true
	q.collide_with_bodies = false
	q.position = p
	return q


func _has_point(_point: Vector2) -> bool:
	var space_state := get_tree().root.world_2d.direct_space_state
	var ips := (
		space_state
		.intersect_point(point_query(get_global_mouse_position()))
		.map(func (ip): return ip.collider))
	return $Area2D in ips
