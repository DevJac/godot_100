extends Button


func _pressed() -> void:
	$'../RowOfCards'.card_order.shuffle()
