extends Node


func bias_v(v: Vector2, bias_v: Vector2, bias_amount: float) -> Vector2:
	if v.distance_to(bias_v) <= bias_amount:
		return bias_v
	return v
