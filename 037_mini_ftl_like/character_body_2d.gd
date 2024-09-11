extends CharacterBody2D
class_name Character


@export var map: Map
@export var character_speed: float = 30


## The character is moving towards the first point in this path,
## or located at that point. This path should never be empty.
@onready var ap_path: PackedInt64Array = [map.astar.get_closest_point(position)]


func begin_path_to(target_point: Vector2) -> void:
	## Move to the AStar point closest to the given point.
	## The given point does not have to be a valid AStar point.
	## This functions calculates a path, and stores that path, and then
	## _process will follow the path each frame.
	var target_ap := map.astar.get_closest_point(target_point)
	var path := map.astar.get_id_path(ap_path[0], target_ap)
	var p0 := map.astar.get_point_position(path[0])
	var p1 := map.astar.get_point_position(path[1])
	if position.distance_squared_to(p0) < position.distance_squared_to(p1):
		path.remove_at(0)
	ap_path = path
	assert(ap_path.size() >= 1)


func follow_path(delta: float) -> void:
	assert(ap_path.size() >= 1)
	var remaining_frame_movement := character_speed * delta
	while true:
		var next_ap_pos := map.astar.get_point_position(ap_path[0])
		var distance_to_next_ap_pos := position.distance_to(next_ap_pos)
		if distance_to_next_ap_pos < remaining_frame_movement:
			position = next_ap_pos
			if ap_path.size() == 1:
				break
			remaining_frame_movement -= distance_to_next_ap_pos
			ap_path.remove_at(0)
			continue
		else:
			var movement_direction := (next_ap_pos - position).normalized()
			position += remaining_frame_movement * movement_direction
			break


func _process(delta: float) -> void:
	follow_path(delta)


func _ready() -> void:
	begin_path_to(Vector2.ZERO)
