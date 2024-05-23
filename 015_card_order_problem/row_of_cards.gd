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
	var co_for_scene_tree: Array[Card] = []
	for i in card_order.size():
		var card: Card = card_order[i]
		card.index = i
		co_for_scene_tree.push_back(card)
	co_for_scene_tree.sort_custom(func(c1, c2):
		if not c1.grabbed and c2.grabbed:
			return true
		return c1.index < c2.index)
	sync_to_scene_tree(co_for_scene_tree)


func sync_to_scene_tree(co_for_scene_tree):
	for card_i: int in co_for_scene_tree.size():
		var card: Card = co_for_scene_tree[card_i]
		var found_matching_child: bool = false
		for child_i: int in range(card_i, get_child_count()):
			var child: Card = get_child(child_i)
			if card == child:
				found_matching_child = true
				if card_i != child_i:
					move_child(child, card_i)
					break
		if not found_matching_child:
			add_child(card)
			move_child(card, card_i)
	for i in range(co_for_scene_tree.size(), get_child_count()):
		remove_child(get_child(i))
