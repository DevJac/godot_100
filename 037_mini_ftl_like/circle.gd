@tool
extends Node2D


@onready var character: Character = get_parent()


func _draw() -> void:
	if not Engine.is_editor_hint() and character.selected:
		draw_circle(Vector2.ZERO, 6, Color.LIGHT_SEA_GREEN)
	else:
		draw_circle(Vector2.ZERO, 6, Color.DARK_GREEN)
	draw_circle(Vector2.ZERO, 5, Color.FOREST_GREEN)
