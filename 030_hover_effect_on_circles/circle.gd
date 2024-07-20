extends Node2D


func _ready() -> void:
	$Area2D.connect('mouse_entered', mouse_entered)
	$Area2D.connect('mouse_exited', mouse_exited)


func mouse_entered():
	$Sprite2D.scale = Vector2.ONE * 1.15


func mouse_exited():
	$Sprite2D.scale = Vector2.ONE
