extends Control


static var test_node_count: int = 351


func _ready() -> void:
	for i in range(1, test_node_count + 1):
		var label := Label.new()
		label.text = str(i)
		@warning_ignore('integer_division')
		label.position = Vector2(50 * (i / 32 + 1), 20 * (i % 32))
		add_child(label)
	var node_list: Array[Node] = []
	for node in get_children():
		if randf() < 0.5:
			node_list.push_back(node)
	for i in range(get_child_count(), get_child_count() + test_node_count + 1):
		var label := Label.new()
		label.text = str(i)
		@warning_ignore('integer_division')
		label.position = Vector2(50 * (i / 32 + 1), 20 * (i % 32))
		node_list.push_back(label)
	node_list.shuffle()
	var start_time := Time.get_ticks_msec()
	sync_nodes_to_scene_tree(node_list, self)
	var end_time := Time.get_ticks_msec()
	prints('Time:', end_time - start_time, float(end_time - start_time) / test_node_count)
	assert(get_children().size() == get_child_count())
	assert(get_child_count() == node_list.size())
	prints('Orphaned nodes:', Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))
	prints('Nodes:')
	for i in min(10, node_list.size()):
		assert(node_list[i] == get_child(i))
		prints(
			i, ':\t',
			node_list[i].name, node_list[i].text,
			get_child(i).name, get_child(i).text)


func sync_nodes_to_scene_tree(from: Array[Node], to: Node):
	for from_i: int in from.size():
		var node := from[from_i]
		if node.get_parent() == null:
			to.add_child(node)
		elif node.get_parent() != to:
			node.reparent(to)
		if node.get_index() != from_i:
			to.move_child(node, from_i)
	for _i in to.get_child_count() - from.size():
		var to_remove := to.get_child(-1)
		# It seems free() will remove the node from the scene tree,
		# so explicitly calling remove_child() is optional.
		# We must call free() either way, or we will have orphaned nodes.
		to.remove_child(to_remove)
		to_remove.free()
