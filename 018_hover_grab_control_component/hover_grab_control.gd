class_name HoverGrabControl
extends Control
## Has 3 states: hovered, grabbed, or none of the preceding.
## Can also be clicked and dragged.

signal grab_begin
signal grab_end(drag_stats: DragStats)
signal hover_begin
signal hover_end
signal drag(mouse_motion: InputEventMouseMotion, drag_stats: DragStats)


@export var grabbable_node: CanvasItem
var hovered := false
var grabbed := false
var grabbed_offset := Vector2.ZERO
var grabbed_start_global_position := Vector2.ZERO
var drag_stats := DragStats.new()


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var left_mouse_pressed: bool = event.pressed and event.button_mask & MOUSE_BUTTON_MASK_LEFT
		if not grabbed and left_mouse_pressed:
			grabbed = true
			grabbed_start_global_position = grabbable_node.global_position
			grabbed_offset = grabbed_start_global_position - get_global_mouse_position()
			drag_stats = DragStats.new()
			grab_begin.emit()
		elif grabbed and not left_mouse_pressed:
			grabbed = false
			grab_end.emit(drag_stats)
	if event is InputEventMouseMotion:
		if grabbed:
			drag_stats.drag_position = get_global_mouse_position() + grabbed_offset
			drag_stats.drag_relative = get_global_mouse_position() - grabbed_start_global_position
			drag_stats.drag_cumulative += abs(event.relative)
			drag.emit(event, drag_stats.duplicate())
	if not grabbed and not get_global_rect().has_point(get_global_mouse_position()):
		if hovered:
			hover_end.emit()
		hovered = false


func _on_mouse_entered() -> void:
	if not hovered and not grabbed:
		hovered = true
		hover_begin.emit()


func _on_mouse_exited() -> void:
	if hovered and not grabbed:
		hovered = false
		hover_end.emit()
