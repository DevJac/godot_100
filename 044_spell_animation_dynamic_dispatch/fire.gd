extends Spell

func _play_animations(main: Main) -> void:
	main.pprint('fire animations, with several awaits')
	main.pprint('fire animation 1')
	await main.get_tree().create_timer(randf_range(0.5, 3.0)).timeout
	main.pprint('fire animation 2')
	await main.get_tree().create_timer(randf_range(0.5, 3.0)).timeout
	main.pprint('fire animation 3')
	await main.get_tree().create_timer(randf_range(0.5, 3.0)).timeout
	main.pprint('fire animations finished')
