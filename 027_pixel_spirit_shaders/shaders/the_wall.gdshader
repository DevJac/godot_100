shader_type canvas_item;

float stroke(float x, float s, float w) {
	float d = step(s-w*0.5, x) -
	          step(s+w*0.5, x);
	return clamp(d, 0, 1);
}

void fragment() {
	vec3 color = vec3(stroke(UV.x, 0.5, 0.15));
	COLOR = vec4(color, 1);
}