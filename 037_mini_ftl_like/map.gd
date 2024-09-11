extends TileMapLayer
class_name Map


@export var draw_astar_graph: bool = false


var astar: AStar2D


func _ready() -> void:
	var start_t := Time.get_ticks_usec()
	_build_astar_network()
	var stop_t := Time.get_ticks_usec()
	prints('Build astar network time (usecs):', stop_t - start_t)


func _is_walkable(point: Vector2i) -> bool:
	var cd := get_cell_tile_data(point)
	return tile_set.get_terrain_name(cd.terrain_set, cd.terrain) == 'Walk'


func _connect_adjacent(astar_point_ids: Dictionary, point: Vector2i) -> void:
	for dx in [-1, 0, 1]:
		for dy in [-1, 0, 1]:
			if dx == 0 and dy == 0:
				continue
			var neighbor := point + Vector2i(dx, dy)
			if dx == 0 or dy == 0:
				if neighbor in astar_point_ids:
					astar.connect_points(
						astar_point_ids[point],
						astar_point_ids[neighbor])
			else:
				
				if (	neighbor in astar_point_ids and
						point + Vector2i(dx, 0) in astar_point_ids and
						point + Vector2i(0, dy) in astar_point_ids):
					astar.connect_points(
						astar_point_ids[point],
						astar_point_ids[neighbor])


func _build_astar_network() -> void:
	astar = AStar2D.new()
	var astar_point_ids := {}
	var used_rect := get_used_rect()
	var ur_position := used_rect.position
	var ur_end := used_rect.end
	for x in range(ur_position.x, ur_end.x):
		for y in range(ur_position.y, ur_end.y):
			var tile_point := Vector2i(x, y)
			if _is_walkable(tile_point):
				var pid := astar.get_available_point_id()
				astar.add_point(pid, tile_point)
				astar_point_ids[tile_point] = pid
	for point in astar_point_ids:
		_connect_adjacent(astar_point_ids, point)
	for point in astar_point_ids:
		astar.set_point_position(astar_point_ids[point], map_to_local(point))
