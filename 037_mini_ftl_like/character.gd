extends CharacterBody2D
class_name Character


@export var map: Map
@export var character_speed: float = 20


## The character is moving towards the first point in ap_path,
## or located at that point. This path should never be empty.
@onready var ap_path: PackedInt64Array = [map.astar.get_closest_point(position)]
## This is the last point the player was at.
@onready var last_ap: int = ap_path[0]


const mouse_down_drag_ignore: int = 50
const mouse_down_timeout: int = 500
var mouse_last_down_position: Vector2i = Vector2i.ZERO
var mouse_last_down_time: int = 0


var selected := false


func begin_path_to_profiled(target_point: Vector2) -> void:
	var start_t = Time.get_ticks_usec()
	begin_path_to(target_point)
	var end_t = Time.get_ticks_usec()
	prints('Created new character path in %d usecs' % (end_t - start_t))


func begin_path_to(target_point: Vector2) -> void:
	## Move to the AStar point closest to the given point.
	## The given point does not have to be a valid AStar point.
	## This functions calculates a path, and stores that path, and then
	## _process will follow the path each frame.
	var target_ap: int = map.astar.get_closest_point(target_point)
	var character_ap: int = map.astar.get_available_point_id()
	map.astar.add_point(character_ap, position)
	map.astar.connect_points(character_ap, ap_path[0])
	map.astar.connect_points(character_ap, last_ap)
	ap_path = map.astar.get_id_path(character_ap, target_ap)
	ap_path.remove_at(0)
	map.astar.remove_point(character_ap)
	assert(ap_path.size() >= 1)


func follow_path(delta: float) -> void:
	assert(ap_path.size() >= 1)
	var remaining_frame_movement := character_speed * delta
	while true:
		var next_ap_pos := map.astar.get_point_position(ap_path[0])
		var distance_to_next_ap_pos := position.distance_to(next_ap_pos)
		if distance_to_next_ap_pos < remaining_frame_movement:
			position = next_ap_pos
			last_ap = ap_path[0]
			if ap_path.size() == 1:
				break
			remaining_frame_movement -= distance_to_next_ap_pos
			ap_path.remove_at(0)
			continue
		else:
			assert(distance_to_next_ap_pos > remaining_frame_movement)
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
				begin_path_to_profiled(map.to_local(e.global_position))
