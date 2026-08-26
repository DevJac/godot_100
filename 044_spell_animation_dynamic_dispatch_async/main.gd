class_name Main
extends Node

const Fire: GDScript = preload('res://fire.gd')
const Ice: GDScript = preload('res://ice.gd')

func _ready() -> void:
	pprint('_ready begin')
	pprint('==== ice alone')
	var ice: Spell = Ice.new()
	ice.play_animations(self)
	await ice.wait_for_animations_to_finish()
	pprint('==== fire alone x3')
	var fire: Spell = Fire.new()
	fire.play_animations(self)
	fire.play_animations(self)
	fire.play_animations(self)
	await fire.wait_for_animations_to_finish()
	pprint('==== fire and ice')
	fire.play_animations(self)
	ice.play_animations(self)
	await ice.wait_for_animations_to_finish()
	await fire.wait_for_animations_to_finish()
	await ice.wait_for_animations_to_finish() # extra call for testing
	pprint('_ready end')
	await get_tree().create_timer(90).timeout
	pprint('really done')

func pprint(msg: Variant) -> void:
	print('[%6d %8.3f] %s' % [
		Engine.get_process_frames(), Time.get_ticks_msec() / 1000.0, msg])
