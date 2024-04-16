shader_type canvas_item;

uniform float fov : hint_range(0, 1) = 0.5;
uniform float inset : hint_range(0, 1) = 0.0;
uniform float x_rot : hint_range(-180, 180) = 0;
uniform float y_rot : hint_range(-180, 180) = 0;

varying float z_inv;

// Right-hand (clockwise) rotation matrices
// See: https://en.wikipedia.org/wiki/Rotation_matrix
mat3 rot_x(float theta) {
	float s = sin(theta);
	float c = cos(theta);
	// These matrices are column major
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
	// We project the vertices onto a 2x2 quad centered at 0. It is only
	// centered at 0 for now, in the next steps we will move it along
	// the z-axis, and center it at (x=0, y=0, z=1).
	vec3 norm_vert3 = vec3(VERTEX * TEXTURE_PIXEL_SIZE * 2.0, 0.0);
	// We apply our rotation to the normalized quad vertices
	// (2x2, centered at 0).
	norm_vert3 = rot_x(radians(x_rot)) * rot_y(radians(y_rot)) * norm_vert3;
	// We scale the z axis by a number between 0 and 1. This will move the
	// z-coordinates closer to zero and will control how much perspective there
	// is. This closely simulates a FOV, with 0 corresponding to a 0 degree FOV,
	// and 1 corresponding to a 180 degree FOV.
	
	// The math behind this step is:
	// The function t(x) = (1 / (tan(x / 2)) + 1 gives the z-coordinate we
	// should center the 2x2 quad at for the desired FOV perspective. When the
	// quad is near, the perspective is extremem, and when very far the
	// perspective is eliminated (orthographic). To maintain the apparent size
	// we must scale the x and y axis by the z coordinate. If the quad is 10
	// times as far away, it must be 10 times as large in world space to appear
	// the same size in screen space. We do not scale the z-axis though, and
	// the more we scale x and y, the more insignificant z becomes. 1 / t(x)
	// give an approximately linear function between 0 and 1, meaning that
	// when the quad is close (FOV = 180 degrees), the z-axis is the same scale
	// as the xy-axis, a ratio of 1. When the quad is far the z-axis becomes
	// insignificant compares to the scaled xy-axis, a ratio of 0 at infinity
	// (FOV = 0 degrees, orthographic). This isn't a perfectly linear
	// relationship, but graphing these functions will show they are close
	// enough to linear, so we use a linear scaling of the z-axis here.
	
	// Instead of making the z-axis insignificant by moving the quad far away
	// and scaling the xy-axis, we scale only the z-axis with this multiplier.
	norm_vert3.z *= fov;
	// The quad may be placed some extra distance from the camera.
	// This can help keep it in a defined area no matter what the rotation is.
	norm_vert3.z += 1.0 + inset;
	// z cannot be linearly interpolated between the vertices, or rather,
	// it can, but it is incorrect. 1 / z can be linearly interpolated though.
	// We set a varying for this vertex and then OpenGL / Vulkan will
	// interpolate the correct values for each fragment between the vertices.
	// Because we're working in 2D here (this is a 2D Godot shader) the values
	// will be linearly interpolated, which workes fine for 2D, but not for
	// 3D perspective. This 2D shader doesn't know what to do with z. We can set
	// z as a varying, but it will be a linearly interpolated varying, so
	// instead we set the varying to 1 / z, which can be interpolated linearly.
	z_inv = 1.0 / norm_vert3.z;
	// This 2D shader will also interpolate the UV coordinates linearly which
	// wont work in 3D. We will let our UV coordinates "ride" on the z-inverse
	// (which can be linearly interpolated) by multiplying them by z_inv. We
	// will have to undo this in the fragment shader.
	UV *= z_inv;
	// Here is our perspective divide.
	norm_vert3.xy /= norm_vert3.z;
	VERTEX = norm_vert3.xy / TEXTURE_PIXEL_SIZE / 2.0;
}

void fragment() {
	// z_inv can be linearly interpolated, and so can z_inv * UV. We want
	// our original UVs, but these aren't quite the original UVs.
	// These UVs have "ridden" to their correct 3D perspective values
	// on the back of z_inv. It's time for the UV's to get off the z_inv horse
	// and we will have the perspective-corrected version of the original UVs.
	COLOR = texture(TEXTURE, UV / z_inv);
}
