extends Control


func _on_timer_timeout():
	var sprite = $Sprite2D
	var match = sprite.position == Vector2(128, 320)
	if sprite.position == Vector2(128, 320):
		var tween = create_tween()
		(tween.tween_property(sprite, 'position', (Vector2(1024, 320) + sprite.position) / 2.0, 0.8)
		.set_ease(Tween.EASE_IN)
		.set_trans(Tween.TRANS_BOUNCE))
		(tween.tween_property(sprite, 'position', Vector2(1024, 320), 0.8)
		.set_ease(Tween.EASE_OUT)
		.set_trans(Tween.TRANS_SPRING))
	elif sprite.position == Vector2(1024, 320):
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_QUAD)
		tween.tween_property(sprite, 'position', Vector2(128, 320), 1.5)
