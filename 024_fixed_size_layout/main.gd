extends Control


func _ready() -> void:
	prints('Default Window.min_size:', get_window().min_size)
	get_window().min_size = get_window().get_contents_minimum_size()
	prints('Contents minimum size:', get_window().get_contents_minimum_size())
	prints('Custom Window.min_size:', get_window().min_size)

	# Here are some ways to add a margin around the edge of the window

	# get_window().content_scale_factor = 0.95

	# get_window().content_scale_size *= 1.05
	# get_window().size.x /= 1.05

	# get_window().content_scale_size += Vector2i(40, 40)
	# get_window().size.x -= 40
