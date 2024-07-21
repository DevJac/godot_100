extends Node2D
class_name Circle


func scale_up():
	$Sprite2D.scale = Vector2.ONE * 1.15


func scale_down():
	$Sprite2D.scale = Vector2.ONE
