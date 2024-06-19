extends Control


var current_layout: Control


func _ready() -> void:
	get_window().connect('size_changed', on_size_changed)
	sync_layout_with_size()


func on_size_changed():
	sync_layout_with_size()


class SizeLayout:
	var size: Vector2
	var layout: Control

	func _init(_size: Vector2, _layout: Control) -> void:
		self.size = _size
		self.layout = _layout


func nearest_ratio_layout(target_ratio, available_layouts) -> SizeLayout:
	var nearest_layout_distance: float = INF
	var nearest_layout: Control;
	var nearest_size: Vector2;
	for layout: Control in available_layouts:
		var r: float = layout.size.x / layout.size.y
		if abs(target_ratio - r) < nearest_layout_distance:
			nearest_layout_distance = abs(target_ratio - r)
			nearest_layout = layout
			nearest_size = layout.size
	return SizeLayout.new(nearest_size, nearest_layout)


func sync_layout_with_size():
	var s := get_window().size
	var window_ratio := s.x / float(s.y)
	var layouts := $CenterContainer/Layouts.get_children()
	var target_layout := nearest_ratio_layout(window_ratio, layouts)
	if current_layout != target_layout.layout:
		current_layout = target_layout.layout
		prints('new layout')
		var ui = $CenterContainer/UI
		var tween := create_tween()
		tween.set_parallel()
		tween.tween_property(
			ui,
			'custom_minimum_size',
			current_layout.custom_minimum_size,
			2)
		tween.tween_property(
			ui.get_node('ColorRect1'),
			'position',
			current_layout.get_node('ColorRect1').position,
			2)
		tween.tween_property(
			ui.get_node('ColorRect1'),
			'size',
			current_layout.get_node('ColorRect1').size,
			2)
		tween.tween_property(
			ui.get_node('ColorRect2'),
			'position',
			current_layout.get_node('ColorRect2').position,
			2)
		tween.tween_property(
			ui.get_node('ColorRect2'),
			'size',
			current_layout.get_node('ColorRect2').size,
			2)
		tween.tween_property(
			ui.get_node('ColorRect3'),
			'position',
			current_layout.get_node('ColorRect3').position,
			2)
		tween.tween_property(
			ui.get_node('ColorRect3'),
			'size',
			current_layout.get_node('ColorRect3').size,
			2)
		tween.tween_property(
			get_window(),
			'content_scale_size',
			Vector2i(target_layout.size),
			2)
		ui.get_node('ReferenceRect').position = (
			current_layout.get_node('ReferenceRect').position)
		ui.get_node('ReferenceRect').size = (
			current_layout.get_node('ReferenceRect').size)
