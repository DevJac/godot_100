extends Control


var card_positions: Array[Vector2] = []
var card_order: Array[Card] = []


func _ready() -> void:
	for i in get_child_count():
		card_positions.push_back(Vector2(200, 200) + Vector2(50, 0) * i)
		var card: Card = get_child(i)
		card_order.push_back(card)
		card.global_position = card_positions[-1]


func _process(_delta: float) -> void:
	for card: Card in card_order:
		if card.grabbed:
			var nearest_cp := nearest_card_position(card.global_position)
			var card_should_be_at := card_positions.find(nearest_cp)
			var card_is_at := card_order.find(card)
			if card_should_be_at != card_is_at:
				card_order.remove_at(card_is_at)
				card_order.insert(card_should_be_at, card)
	for i in card_order.size():
		var card: Card = card_order[i]
		if not card.grabbed:
			card.global_position = card_positions[i]
	sync_card_order_to_child_order()


func nearest_card_position(x: Vector2) -> Vector2:
	var min_dist := INF
	var nearest_cp: Vector2
	for card_position: Vector2 in card_positions:
		var dist := card_position.distance_squared_to(x)
		if dist < min_dist:
			min_dist = dist
			nearest_cp = card_position
	return nearest_cp


func sync_card_order_to_child_order():

	# Lambda function is named for debugging purposes.
	var custom_comparator := func custom_comparator(c1, c2) -> int:
		# Returns 0 if equal, and 1 if c1 < c2; -1 otherwise.
		if not c1.grabbed and c2.grabbed:
			return 1
		if c1.grabbed == c2.grabbed:
			return 0
		return -1

	var indices := range(card_order.size())
	indices.sort_custom(func(i1, i2):
		var c1 := card_order[i1]
		var c2 := card_order[i2]
		var o: int = custom_comparator.call(c1, c2)
		if o > 0:
			return true
		if o == 0:
			return i1 < i2
		return false)
	sync_to_scene_tree(indices.map(func(i): return card_order[i]))


func sync_to_scene_tree(co_for_scene_tree):
	for card_i: int in co_for_scene_tree.size():
		var card: Card = co_for_scene_tree[card_i]
		if card.get_parent() == self:
			if card.get_index() != card_i:
				move_child(card, card_i)
		else:
			add_child(card)
			move_child(card, card_i)
	for i in range(co_for_scene_tree.size(), get_child_count()):
		remove_child(get_child(i))
