extends PathFollow2D


@export var speed := 0.0


func _process(delta: float) -> void:
	progress += speed * delta
