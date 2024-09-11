extends Node2D


var process_has_printed := false


func _ready() -> void:
	prints('_ready', name)


func _process(delta: float) -> void:
	if not process_has_printed:
		process_has_printed = true
		prints('_process', name)


# Could also be _unhandled_input
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and not event.pressed:
		@warning_ignore('integer_division')
		prints('== %4d ==' % (Time.get_ticks_msec() / 1000), name, event)
