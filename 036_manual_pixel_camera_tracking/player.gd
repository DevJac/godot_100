extends Sprite2D


@export var movement_speed: float = 80


const MOVEMENTS := {
	'move_up': Vector2(0, -1),
	'move_left': Vector2(-1, 0),
	'move_down': Vector2(0, 1),
	'move_right': Vector2(1, 0),
}


var real_global_position := Vector2.ZERO
var last_rendered_position := Vector2.ZERO


func _ready() -> void:
	real_global_position = global_position
	last_rendered_position = global_position.round()


func _process(delta: float) -> void:
	if ProjectSettings.get_setting('application/run/max_fps') != 0:
		delta *= ProjectSettings.get_setting('application/run/max_fps') / 60.0

	var movement_direction := get_movement_direction()
	real_global_position += movement_direction * movement_speed * delta
	global_position = round_position(real_global_position, movement_direction)
	last_rendered_position = global_position
	assert(global_position == global_position.round())


# The next 2 functions identify the major axis of motion, and then only update
# the rendered pixel whenever the position along the major axis changes.
# Rounding errors sometimes cause the position on the minor axis to change more
# than the major axis, but we artifically prevent this. This creates additional
# error in the rendered position, but this error is in the minor axis and will
# thus dissipate over time.
@warning_ignore('shadowed_variable_base_class')
func round_position(
		position: Vector2,
		movement_direction: Vector2
		) -> Vector2:
	assert(last_rendered_position == last_rendered_position.round())
	var result: Vector2
	if abs(movement_direction.x) < abs(movement_direction.y):
		result = round_position_x_major(
			Vector2(position.y, position.x),
			Vector2(movement_direction.y, movement_direction.x))
		result = Vector2(result.y, result.x)
	else:
		result = round_position_x_major(position, movement_direction)
	assert(result == result.round())
	if abs(result.x - position.x) > 1 or abs(result.y - position.y) > 1:
		prints('large error')
	return result


@warning_ignore('shadowed_variable_base_class')
func round_position_x_major(
		position: Vector2,
		movement_direction: Vector2
		) -> Vector2:
	assert(abs(movement_direction.x) >= abs(movement_direction.y))
	if movement_direction.length_squared() < 0.1:
		return position.round()
	if round(position.x) == last_rendered_position.x:
		return last_rendered_position
	else:
		var r := position.round()
		var x_change: float = abs(r.x - last_rendered_position.x)
		var y_change: float = abs(r.y - last_rendered_position.y)
		if x_change < y_change:
			r.y -= sign(r.y - last_rendered_position.y)
		return r


func get_movement_direction() -> Vector2:
	var integrated_movement := Vector2.ZERO
	for movement in MOVEMENTS:
		integrated_movement += (
			Input.get_action_strength(movement) * MOVEMENTS[movement])
	if integrated_movement.length_squared() > 1:
		return integrated_movement.normalized()
	return integrated_movement
