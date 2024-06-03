class_name DragStats
extends RefCounted


var drag_position := Vector2.ZERO
var drag_relative := Vector2.ZERO
var drag_cumulative := Vector2.ZERO


func duplicate() -> DragStats:
	var dup = DragStats.new()
	dup.drag_position = self.drag_position
	dup.drag_relative = self.drag_relative
	dup.drag_cumulative = self.drag_cumulative
	return dup
