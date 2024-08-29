extends Sprite2D


@export var movement_speed: float = 50


const MOVEMENTS := {
	'move_up': Vector2(0, -1),
	'move_left': Vector2(-1, 0),
	'move_down': Vector2(0, 1),
	'move_right': Vector2(1, 0),
}


var real_global_position = Vector2.ZERO
var last_global_position = Vector2.ZERO


func _ready() -> void:
	real_global_position = global_position
	last_global_position = global_position


func _process(delta: float) -> void:
	real_global_position += get_movement_direction() * movement_speed * delta
	global_position = (
		Utils.bias_v(real_global_position, last_global_position, 0.75)
		.round())
	last_global_position = global_position
	assert(global_position == global_position.round())
	prints(global_position)


func get_movement_direction() -> Vector2:
	var integrated_movement := Vector2.ZERO
	for movement in MOVEMENTS:
		integrated_movement += (
			Input.get_action_strength(movement) * MOVEMENTS[movement])
	if integrated_movement.length_squared() > 1:
		return integrated_movement.normalized()
	return integrated_movement
