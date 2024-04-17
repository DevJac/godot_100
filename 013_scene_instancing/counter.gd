@tool
extends Control

signal changed(new_count)

@export
var count: int = 0:
	set(value):
		count = value
		$VBoxContainer/Label.text = str(count)
		if not Engine.is_editor_hint():
			changed.emit(value)

func _ready() -> void:
	$VBoxContainer/Label.text = str(count)

func _on_button_pressed() -> void:
	count += 1
	$VBoxContainer/Label.text = str(count)
