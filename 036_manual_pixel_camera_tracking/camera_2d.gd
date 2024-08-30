extends Camera2D


@export var target: Node2D
@export var tracking_speed: float = 8


var real_global_position := Vector2.ZERO
var last_global_position := Vector2.ZERO


func _ready() -> void:
	real_global_position = target.global_position
	last_global_position = target.global_position


func _process(delta: float) -> void:
	if ProjectSettings.get_setting('application/run/max_fps') != 0:
		delta *= ProjectSettings.get_setting('application/run/max_fps') / 60.0

	real_global_position = real_global_position.lerp(
		target.real_global_position,
		1 - exp(-delta * tracking_speed))

	global_position = (
		target.global_position
		+ (self.real_global_position - target.real_global_position).round())
	var new_distance_to_target = (
		global_position.distance_squared_to(target.real_global_position))
	var last_distance_to_target = (
		last_global_position.distance_squared_to(target.real_global_position))
	# Do not move the camera away from the target.
	# The target can get further away from the camera by moving away from the
	# camera, but the camera should never move away from the target.
	# This prevents jitter.
	if new_distance_to_target > last_distance_to_target:
		global_position = last_global_position
	last_global_position = global_position
	assert(global_position == global_position.round())
	prints('p_pos: %-20s     c_pos: %-20s     diff: %-20s' % [
		target.global_position,
		self.global_position,
		target.global_position.distance_to(self.global_position),
	])
