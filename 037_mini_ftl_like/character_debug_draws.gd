extends Node2D


@onready var character: Character = get_parent()


func _process(_delta: float) -> void:
	queue_redraw()


func map_to_local(v: Vector2) -> Vector2:
	return to_local(character.map.to_global(v))


func draw_ap(ap: int, color: Color) -> void:
	var pos := map_to_local(character.map.astar.get_point_position(ap))
	draw_circle(pos, 1, color)


func _draw() -> void:
	draw_line(
		map_to_local(character.map.astar.get_point_position(character.last_ap_path_0)),
		map_to_local(character.map.astar.get_point_position(character.ap_path[0])),
		Color.BLUE,
		0.5)
	for i in range(character.ap_path.size() - 1):
		draw_line(
			map_to_local(character.map.astar.get_point_position(character.ap_path[i])),
			map_to_local(character.map.astar.get_point_position(character.ap_path[i+1])),
			Color.CYAN,
			0.5)
	for ap in character.ap_path:
		draw_ap(ap, Color.CYAN)
	draw_ap(character.last_ap_path_0, Color.BLUE)
