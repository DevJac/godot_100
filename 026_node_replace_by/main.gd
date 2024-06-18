extends Control


func _ready() -> void:
	var timer = Timer.new()
	timer.autostart = true
	timer.wait_time = 1.0
	timer.connect('timeout', func():
		var control = $Control
		var old_node = control.get_child(0)
		var new_node = ColorRect.new()
		new_node.position = old_node.position
		new_node.size = old_node.size
		assert(old_node is ColorRect)
		assert(new_node is ColorRect)
		old_node.replace_by(new_node)
		# The above line (with replace_by) does roughly the same as the
		# following 2 lines. The main difference is replace_by will handle
		# removing the child from the correct index and adding the new child at
		# the (same) correct index, as we would expect.
		# $Control.remove_child(old_node)
		# $Control.add_child(new_node)
		old_node.free()
		prints('replaced')
	)
	add_child(timer)
