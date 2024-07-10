extends Control


func _ready() -> void:
	var t = Timer.new()
	t.autostart = true
	t.wait_time = 2
	t.one_shot = true
	t.connect('timeout', func ():
		prints('moving')
		var color_rect = $A/AA/ColorRect
		color_rect.reparent($B/BA/BAA)
	)
	add_child(t)


func _on_aa_child_exiting_tree(exiting_child_node: Node) -> void:
	prints('child node is exiting')
	exiting_child_node.color = Color.RED
