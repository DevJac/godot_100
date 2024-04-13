shader_type canvas_item;

// Right-hand (clockwise) rotation matrices
// See: https://en.wikipedia.org/wiki/Rotation_matrix
mat3 rot_x(float theta) {
	float s = sin(theta);
	float c = cos(theta);
	return mat3(
		vec3(1, 0, 0),
		vec3(0, c, s),
		vec3(0, -s, c)
	);
}

mat3 rot_y(float theta) {
	float s = sin(theta);
	float c = cos(theta);
	return mat3(
		vec3(c, 0, -s),
		vec3(0, 1, 0),
		vec3(s, 0, c)
	);
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
