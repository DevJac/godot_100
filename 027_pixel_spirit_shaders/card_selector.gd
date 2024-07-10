@tool
extends Button

@export var card_name: String:
	set(new_value):
		card_name = new_value
		text = card_name

@export var shader: Shader


func _pressed() -> void:
	var card = get_parent().get_node('Card')
	card.card_name = card_name
	card.shader = shader
