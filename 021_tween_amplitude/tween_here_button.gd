extends Button


@export var tween_amplitude: float = 1.0
@export var tween_time: float = 2.0


func _pressed() -> void:
	var cr: ColorRect = $'../ColorRect'
	if is_instance_valid(cr.tween):
		cr.tween.kill()
	cr.tween = cr.create_tween()
	var tween_target = position
	tween_target.y = 128
	
	var start = cr.position
	var end = tween_target
	
	var tween_method = func tween_method(t: float):
		var x: float = (t-1)**2 * ((tween_amplitude + 1) * (t-1) + tween_amplitude) + 1
		cr.position = start + (end - start) * x
	
	cr.tween.tween_method(tween_method, 0.0, 1.0, tween_time)
