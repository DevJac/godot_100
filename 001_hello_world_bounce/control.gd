extends Control


var default_velocity: float = 100.0
var label_velocity: Vector2 = Vector2(default_velocity, default_velocity)


func _process(delta):
	var label = $Label
	label.position += label_velocity * delta
	# Right, Left, Bottom, Top Bounces
	var label_lower_right = label.position + label.size
	if label_lower_right.x > size.x:
		label_velocity.x = -default_velocity
	if label.position.x < 0:
		label_velocity.x = default_velocity
	if label_lower_right.y > size.y:
		label_velocity.y = -default_velocity
	if label.position.y < 0:
		label_velocity.y = default_velocity
