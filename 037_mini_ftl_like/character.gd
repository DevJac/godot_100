extends CharacterBody2D
class_name Character


@export var map: Map
@export var character_speed: float = 10


## The character is moving towards the first point in ap_path,
## or located at that point. This path should never be empty.
@onready var ap_path: PackedInt64Array = [map.astar.get_closest_point(position)]
## This is the last point the player was moving towards.
## The player is on the line segment from last_ap_path_0 to ap_path[0],
## possibly at the ap_path[0] end. 
@onready var last_ap_path_0: int = ap_path[0]


const mouse_down_drag_ignore: int = 50
const mouse_down_timeout: int = 500
var mouse_last_down_position: Vector2i = Vector2i.ZERO
var mouse_last_down_time: int = 0


func begin_path_to(target_point: Vector2) -> void:
	## Move to the AStar point closest to the given point.
	## The given point does not have to be a valid AStar point.
	## This functions calculates a path, and stores that path, and then
	## _process will follow the path each frame.
	var target_ap: int = map.astar.get_closest_point(target_point)
	ap_path = map.astar.get_id_path(ap_path[0], target_ap)
	if ap_path.size() == 1:
		return
	if ap_path[1] == last_ap_path_0:
		last_ap_path_0 = ap_path[0]
		ap_path.remove_at(0)
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
			last_ap_path_0 = ap_path[0]
			ap_path.remove_at(0)
			continue
		else:
			var movement_direction := (next_ap_pos - position).normalized()
			position += remaining_frame_movement * movement_direction
			break


func _process(delta: float) -> void:
	follow_path(delta)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var e: InputEventMouseButton = event
		if e.button_index == MOUSE_BUTTON_LEFT:
			if e.pressed:
				mouse_last_down_position = e.position
				mouse_last_down_time = Time.get_ticks_msec()
			else:
				assert(not e.pressed)
				var motion_while_pressed := (
					e.position.distance_squared_to(mouse_last_down_position))
				if motion_while_pressed > mouse_down_drag_ignore:
					return
				var time_while_pressed := (
					Time.get_ticks_msec() - mouse_last_down_time)
				if time_while_pressed > mouse_down_timeout:
					return
				begin_path_to(map.to_local(e.global_position))
