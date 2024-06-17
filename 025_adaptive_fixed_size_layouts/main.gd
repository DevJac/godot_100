extends Control


const ratio_scenes = {
	Vector2(1152.0, 648.0): 'res://wide.tscn',
	Vector2(648.0, 1152.0): 'res://tall.tscn',
}


var current_scene: String = 'res://wide.tscn';


func _ready() -> void:
	get_window().connect('size_changed', on_size_changed)
	sync_scene_with_size()


func on_size_changed():
	sync_scene_with_size()


class SizeScene:
	var size: Vector2
	var scene: String

	func _init(_size: Vector2, _scene: String) -> void:
		self.size = _size
		self.scene = _scene


func nearest_ratio_scene(target_ratio, available_ratio_scenes) -> SizeScene:
	var nearest_scene_distance: float = INF
	var nearest_scene: String;
	var nearest_size: Vector2;
	for scene_size in available_ratio_scenes:
		var r: float = scene_size.x / scene_size.y
		if abs(target_ratio - r) < nearest_scene_distance:
			nearest_scene_distance = abs(target_ratio - r)
			nearest_scene = available_ratio_scenes[scene_size]
			nearest_size = scene_size
	return SizeScene.new(nearest_size, nearest_scene)


func sync_scene_with_size():
	var s := get_window().size
	var target_scene := nearest_ratio_scene(s.x / float(s.y), ratio_scenes)
	if current_scene != target_scene.scene:
		current_scene = target_scene.scene
		assert($CenterContainer.get_child_count() == 1)
		$CenterContainer.get_child(0).free()
		# Preloading would probably be better, but I wanted to try load.
		# There is no perceivable delay using load on a project this small.
		$CenterContainer.add_child(load(target_scene.scene).instantiate())
		get_window().content_scale_size = target_scene.size
