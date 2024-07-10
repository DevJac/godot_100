@tool
extends ColorRect


@export var card_name: String:
	set(new_value):
		card_name = new_value
		$NameLabel.text = card_name

@export var shader: Shader:
	set(new_value):
		shader = new_value
		material.shader = shader
		material.set_shader_parameter('resolution', size)


func _ready() -> void:
	get_tree().connect('node_added', show_latest_shader)
	get_tree().connect('node_removed', show_latest_shader)


func show_latest_shader(_node):
	var latest_card_selector := get_parent().get_child(get_parent().get_child_count() - 1)
	shader = latest_card_selector.shader
