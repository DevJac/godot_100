extends Node2D


## The mouse location when the mouse button was first pressed,
## marks the starting position of the selection rectangle.
var selection_start: Vector2 = Vector2.ZERO
## selection_end is tracked so the other corner is known when drawing.
var selection_end: Vector2 = Vector2.ZERO
## drawing_box will be true when we are drawing a selection box,
## the mouse button is pressed during this time
var drawing_box: bool = false
var selected_characters: Array[Character] = []


func get_selection_rect() -> Rect2:
	# Top Left
	var tl := Vector2(
		min(selection_start.x, selection_end.x),
		min(selection_start.y, selection_end.y))
	# Bottom Right
	var br := Vector2(
		max(selection_start.x, selection_end.x),
		max(selection_start.y, selection_end.y))
	return Rect2(tl, br - tl)


func make_selection():
	var selection_rect := get_selection_rect()
	var unit_rect_shape := RectangleShape2D.new()
	unit_rect_shape.size = Vector2.ONE
	var unit_rect_shape_transform := Transform2D(
		Vector2(selection_rect.size.x + 0.001, 0),
		Vector2(0, selection_rect.size.y + 0.001),
		to_global(selection_rect.position) + selection_rect.size / 2)
	var shape_query := PhysicsShapeQueryParameters2D.new()
	shape_query.shape = unit_rect_shape
	shape_query.transform = unit_rect_shape_transform
	var pdss: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var intersections := pdss.intersect_shape(shape_query)
	var selection_this_frame: Array[Character]
	selection_this_frame.assign(intersections.map(func(i):
		return i.collider))
	var characters_to_erase: Array[Character] = []
	for character: Character in selected_characters:
		if character not in selection_this_frame:
			characters_to_erase.append(character)
			character.selected = false
	for character: Character in characters_to_erase:
		selected_characters.erase(character)
	for character: Character in selection_this_frame:
		if character not in selected_characters:
			selected_characters.append(character)
			character.selected = true


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index != MOUSE_BUTTON_LEFT:
			return
		assert(event.button_index == MOUSE_BUTTON_LEFT)
		queue_redraw()
		if not drawing_box and event.pressed:
			drawing_box = true
			selection_start = to_local(event.global_position)
			selection_end = to_local(event.global_position)
		if drawing_box and not event.pressed:
			drawing_box = false
			make_selection()
	if event is InputEventMouseMotion:
		if drawing_box:
			selection_end = to_local(event.global_position)
			queue_redraw()
			make_selection()


func _draw() -> void:
	if drawing_box:
		draw_rect(get_selection_rect(), Color.GREEN, false, 1, false)
