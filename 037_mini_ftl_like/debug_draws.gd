extends Node2D


var dots: Array[Vector2] = []
var connections: Array[Vector2] = []


func _draw() -> void:
	var astar: AStar2D = get_parent().astar
	for i in astar.get_point_ids():
		var a := astar.get_point_position(i)
		for connection in astar.get_point_connections(i):
			var b := astar.get_point_position(connection)
			draw_line(a, b, Color.RED, 1)
	for i in astar.get_point_ids():
		var point := astar.get_point_position(i)
		draw_circle(point, 2, Color.RED)
