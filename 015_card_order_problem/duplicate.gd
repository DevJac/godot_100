extends Button


func _pressed() -> void:
	var cp = $'../RowOfCards'.card_positions
	var co = $'../RowOfCards'.card_order
	cp.push_back(cp[-1] + Vector2(50, 0))
	co.push_back(co[-1].duplicate())
