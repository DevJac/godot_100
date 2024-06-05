extends Path2D


func _ready() -> void:
	for i in get_child_count():
		var child: Sprite2D = get_child(i)
		var t := curve.sample_baked_with_rotation(
			i * curve.get_baked_length() / (get_child_count()-1),
			true)
		if i == 0:
			# global_position and position are the same,
			# since our parent node(s) are positioned at the origin
			child.position = t.get_origin()
		else:
			prints(t.rotated(deg_to_rad(90)))
			child.transform = t.rotated_local(deg_to_rad(-90))
