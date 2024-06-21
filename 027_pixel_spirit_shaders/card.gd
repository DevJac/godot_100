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
