extends Sprite2D


@export var movement_speed: float = 50


const MOVEMENTS := {
	'move_up': Vector2(0, -1),
	'move_left': Vector2(-1, 0),
	'move_down': Vector2(0, 1),
	'move_right': Vector2(1, 0),
}


var real_global_position = Vector2.ZERO


func _ready() -> void:
	real_global_position = global_position


func _process(delta: float) -> void:
	if ProjectSettings.get_setting('application/run/max_fps') != 0:
		delta *= ProjectSettings.get_setting('application/run/max_fps') / 60.0

	real_global_position += get_movement_direction() * movement_speed * delta
	global_position = real_global_position.round()
	assert(global_position == global_position.round())


func get_movement_direction() -> Vector2:
	var integrated_movement := Vector2.ZERO
	for movement in MOVEMENTS:
		integrated_movement += (
			Input.get_action_strength(movement) * MOVEMENTS[movement])
	if integrated_movement.length_squared() > 1:
		return integrated_movement.normalized()
	return integrated_movement
