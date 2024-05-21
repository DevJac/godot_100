extends Control


var card_positions: Array[Vector2] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in 4:
		card_positions.push_back(Vector2(200, 200) + Vector2(50, 0) * i)
		var card: Card = get_child(i)
		card.position = card_positions[-1]


func nearest_card_position(x: Vector2) -> Vector2:
	var min_dist := INF
	var nearest_cp: Vector2
	for card_position: Vector2 in card_positions:
		var dist := card_position.distance_squared_to(x)
		if dist < min_dist:
			min_dist = dist
			nearest_cp = card_position
	return nearest_cp


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var card_position_nearest_grabbed_card: Vector2
	for card: Card in get_children():
		if card.grabbed:
			var nearest_cp := nearest_card_position(card.global_position)
			move_child(card, card_positions.find(nearest_cp))
			card.z_index = 1
		else:
			card.z_index = 0
	for i in get_child_count():
		var card: Card = get_child(i)
		if not card.grabbed:
			card.global_position = card_positions[i]
