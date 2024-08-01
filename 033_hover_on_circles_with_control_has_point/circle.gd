extends Node2D


var mouse_inside: bool = false


func _ready() -> void:
	$Sprite2D/Control.connect('mouse_entered', mouse_entered)
	$Sprite2D/Control.connect('mouse_exited', mouse_exited)


func mouse_entered():
	$Sprite2D.scale = Vector2.ONE * 1.15


func mouse_exited():
	$Sprite2D.scale = Vector2.ONE
