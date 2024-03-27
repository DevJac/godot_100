extends Control


var count: int = 0


func _on_button_pressed():
	count += 1
	$VBox/MarginContainer/Label.text = str(count)
