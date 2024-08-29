extends Camera2D


@export var target: Node2D
@export var tracking_speed: float = 3


var real_global_position := Vector2.ZERO


func _ready() -> void:
	real_global_position = target.global_position


func _process(delta: float) -> void:
	if ProjectSettings.get_setting('application/run/max_fps') != 0:
		delta *= ProjectSettings.get_setting('application/run/max_fps') / 60.0

	real_global_position = real_global_position.lerp(
		target.real_global_position,
		1 - exp(-delta * tracking_speed))
	var correction: Vector2 = (
		target.real_global_position - self.real_global_position).posmod(1)
	global_position = (real_global_position + correction).round()
	assert(global_position == global_position.round())
	prints('p_pos: %-20s     c_pos: %-20s     diff: %-20s' % [
		target.global_position,
		self.global_position,
		target.global_position.distance_to(self.global_position),
	])
