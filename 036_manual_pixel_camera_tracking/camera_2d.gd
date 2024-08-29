extends Camera2D


@export var target: Node2D
@export var tracking_speed: float = 3
@export var drag_speed: float = 20


var real_global_position := Vector2.ZERO
var real_drag := Vector2.ZERO
var last_biased_real_drag := Vector2.ZERO


func _ready() -> void:
	real_global_position = target.global_position


func _process(delta: float) -> void:
	real_global_position = real_global_position.lerp(
		target.real_global_position,
		1 - exp(-delta * tracking_speed))
	var ideal_drag: Vector2 = (
		real_global_position - target.real_global_position)
	real_drag += (ideal_drag - real_drag).normalized() * drag_speed * delta
	var biased_real_drag := Utils.bias_v(
		real_drag,
		last_biased_real_drag,
		1)
	last_biased_real_drag = biased_real_drag
	global_position = (target.global_position + biased_real_drag).round()
	assert(global_position == global_position.round())
	prints(target.global_position,
		global_position,
		target.global_position.distance_to(global_position))
