extends Node2D

var direct_space_state: PhysicsDirectSpaceState2D 
var currently_hovered_circle: Circle:
	set(value):
		if currently_hovered_circle == value: return
		print(value)
		
		if currently_hovered_circle != null: 
			currently_hovered_circle.scale_down()
		
		if value != null:
			value.scale_up()
		
		currently_hovered_circle = value

func _ready() -> void:
	direct_space_state = get_tree().root.world_2d.direct_space_state


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var params := PhysicsPointQueryParameters2D.new()
		params.collide_with_areas = true
		#params.collision_mask = you can optionally provide a layermask for the areas if you wish
		
		params.position = get_global_mouse_position()
		
		var result: Array[Dictionary] = direct_space_state.intersect_point(params)
		if !result.is_empty():
			
			result.sort_custom(sort_based_on_tree_order)
			
			#print(result)
			var circle: Circle = result[0].collider.owner as Circle
			#print(circle.name)
			currently_hovered_circle = circle
			#print("_____________________________________")
		else:
			currently_hovered_circle = null #if nothing is hovered, set to null

func sort_based_on_tree_order(dict_a, dict_b):
	var circle_a := dict_a.collider.owner as Circle
	var circle_b := dict_b.collider.owner as Circle
	
	return circle_a.is_greater_than(circle_b)
