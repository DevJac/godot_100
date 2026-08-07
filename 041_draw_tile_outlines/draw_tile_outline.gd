extends Node2D

var tiles: Dictionary[Vector2i, bool] = {
	Vector2i(0, 0): true,
	Vector2i(0, -1): true,
	Vector2i(-1, 0): true,
	Vector2i(1, 0): true,
	Vector2i(1, -2): true,
}

const DIRECTIONS: Array[Vector2i] = [
	Vector2i.UP,
	Vector2i.DOWN,
	Vector2i.LEFT,
	Vector2i.RIGHT,
]

func _draw() -> void:
	var tile_size_i: Vector2i = Vector2i(16, 16)
	draw_outline(tile_size_i, 1, 0, Color(1, 1, 1, 1))
	draw_outline(tile_size_i, 1, -1, Color(1, 0, 0, 0.5))
	draw_outline(tile_size_i, 1, -2, Color(0, 0, 1, 0.25))

func draw_outline(
		tile_size_i: Vector2i,
		width: float,
		outer_offset: float,
		color: Color
	) -> void:
	var half: Vector2 = tile_size_i / 2.0
	for tile_i: Vector2i in tiles:
		var center: Vector2 = Vector2(tile_i * tile_size_i) + half
		# direction_u is a UNIT vector pointing towards a nearby tile;
		# we MIGHT need to draw a boundary if the nearby tile is not in tiles.
		for direction_u: Vector2i in DIRECTIONS:
			if tiles.has(tile_i + direction_u):
				continue
			# We now know that tile + direction is NOT in the tiles,
			# so we need to draw an outline boundary.
			var perp_u: Vector2i = Vector2i(direction_u.y, -direction_u.x)
			var direction: Vector2 = Vector2(direction_u) * half
			var perp: Vector2 = Vector2(perp_u) * half
			var outer_edge_a: Vector2 = center + direction + outer_offset * direction_u + perp
			var outer_edge_b: Vector2 = center + direction + outer_offset * direction_u - perp
			var inner_edge_a: Vector2 = outer_edge_a + (width * -direction_u)
			var inner_edge_b: Vector2 = outer_edge_b + (width * -direction_u)
			# We now need to miter the edges
			# if a perpendicular tile is NOT in tiles.
			if not tiles.has(tile_i + perp_u):
				# We need to miter in a bit to fit with another corner.
				outer_edge_a += outer_offset * perp_u
				inner_edge_a += width * -perp_u + outer_offset * perp_u
			elif tiles.has(tile_i + direction_u + perp_u):
				# We need to miter out a bit to fit with another corner.
				outer_edge_a += outer_offset * -perp_u
				inner_edge_a += width * perp_u + outer_offset * -perp_u
			if not tiles.has(tile_i - perp_u):
				outer_edge_b += outer_offset * -perp_u
				inner_edge_b += width * perp_u + outer_offset * -perp_u
			elif tiles.has(tile_i + direction_u - perp_u):
				outer_edge_b += outer_offset * perp_u
				inner_edge_b += width * -perp_u + outer_offset * perp_u
			draw_colored_polygon(
				PackedVector2Array([
					outer_edge_a,
					outer_edge_b,
					inner_edge_b,
					inner_edge_a]),
				color)
