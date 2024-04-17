extends Label

var max_count = 0

func _ready() -> void:
	max_count = max($'../Counter1'.count, $'../Counter2'.count)
	text = str(max_count)

func _on_counter_changed(new_count: Variant) -> void:
	if new_count > max_count:
		max_count = new_count
		text = str(max_count)
