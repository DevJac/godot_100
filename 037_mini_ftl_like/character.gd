extends CharacterBody2D
class_name Character


@export var map: Map
@export var character_speed: float = 20


## The character is moving towards the first point in ap_path,
## or located at that point. This path should never be empty.
@onready var ap_path: PackedInt64Array = [map.astar.get_closest_point(position)]
## This is the last point the player was at.
@onready var last_ap: int = ap_path[0]
@onready var user_specified_ap: int = ap_path[0]


const mouse_down_drag_ignore: int = 50
const mouse_down_timeout: int = 500
var mouse_last_down_position: Vector2i = Vector2i.ZERO
var mouse_last_down_time: int = 0


var selected: bool = false:
	set(new_value):
		if new_value != selected:
			$Circle.queue_redraw()
			selected = new_value


var standing: bool:
	get:
		return ap_path.size() == 1 and ap_path[0] == last_ap


var standing_at:  # returns int or null
	get:
		if standing:
			return last_ap
		return null


var standing_at_position:  # returns Vector2 or null
	get:
		if standing:
			return map.astar.get_point_position(standing_at)
		return null


func begin_path_to_profiled(
		target_point: Vector2,
		user_specified: bool) -> void:
	var start_t = Time.get_ticks_usec()
	begin_path_to(target_point, user_specified)
	var end_t = Time.get_ticks_usec()
	prints('Created new character path in %d usecs' % (end_t - start_t))


func begin_path_to(target_point: Vector2, user_specified: bool) -> void:
	## Move to the AStar point closest to the given point.
	## The given point does not have to be a valid AStar point.
	## This functions calculates a path, and stores that path, and then
	## _process will follow the path each frame.
	var target_ap: int = map.astar.get_closest_point(target_point)
	if user_specified:
		user_specified_ap = target_ap
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
	if ap_is_occupied(ap_path[-1]):
		path_to_nearby_empty_spot(user_specified_ap)
	var remaining_frame_movement := character_speed * delta
	while true:
		var next_ap_pos := map.astar.get_point_position(ap_path[0])
		var distance_to_next_ap_pos := position.distance_to(next_ap_pos)
		if distance_to_next_ap_pos < remaining_frame_movement:
			position = next_ap_pos
			last_ap = ap_path[0]
			if standing:
				if ap_is_occupied(standing_at):
					path_to_nearby_empty_spot(user_specified_ap)
				break
			remaining_frame_movement -= distance_to_next_ap_pos
			ap_path.remove_at(0)
			continue
		else:
			assert(distance_to_next_ap_pos > remaining_frame_movement)
			var movement_direction := (next_ap_pos - position).normalized()
			position += remaining_frame_movement * movement_direction
			break


func ap_is_occupied(ap: int):
	var all_characters := get_tree().get_nodes_in_group('selectable')
	for other_character: Character in all_characters:
		if other_character == self:
			continue
		if other_character.ap_path[-1] == ap:
			return true
	return false


func ap_connection_cost(ap0: int, ap1: int) -> float:
	var p0 := map.astar.get_point_position(ap0)
	var p1 := map.astar.get_point_position(ap1)
	return p0.distance_to(p1)


func path_to_nearby_empty_spot(from_ap: int):
	var visited_points = {from_ap: null}  # We're just using this as a set
	var q = [[from_ap, 0.0]]  # An array of [ap, cost] tuples
	while q.size() > 0:
		var q0 = q.pop_front()
		var n: int = q0[0]
		var nc: float = q0[1]  # n cost
		if n != from_ap and not ap_is_occupied(n):
			begin_path_to(map.astar.get_point_position(n), false)
			return
		var n_connections: Array[int]
		n_connections.assign(map.astar.get_point_connections(n))
		n_connections.shuffle()
		for n_connection: int in n_connections:
			if n_connection not in visited_points:
				q.append([
					n_connection,
					nc + ap_connection_cost(n, n_connection)])
				visited_points[n_connection] = null
		q.sort_custom(func(a, b): 
			return a[1] < b[1])


func _process(delta: float) -> void:
	follow_path(delta)


func _unhandled_input(event: InputEvent) -> void:
	if not selected:
		return
	assert(selected)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				mouse_last_down_position = event.position
				mouse_last_down_time = Time.get_ticks_msec()
			else:
				assert(not event.pressed)
				var motion_while_pressed: float = (
					event
					.position
					.distance_squared_to(mouse_last_down_position))
				if motion_while_pressed > mouse_down_drag_ignore:
					return
				var time_while_pressed := (
					Time.get_ticks_msec() - mouse_last_down_time)
				if time_while_pressed > mouse_down_timeout:
					return
				begin_path_to_profiled(
					map.to_local(event.global_position),
					true)
