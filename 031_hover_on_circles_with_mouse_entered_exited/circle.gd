extends Node2D


var mouse_inside: bool = false


func _ready() -> void:
	$Area2D.connect('mouse_entered', mouse_entered)
	$Area2D.connect('mouse_exited', mouse_exited)


func mouse_entered():
	mouse_inside = true


func mouse_exited():
	mouse_inside = false
