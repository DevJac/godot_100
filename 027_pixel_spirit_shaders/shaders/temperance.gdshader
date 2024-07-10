shader_type canvas_item;

float stroke(float x, float s, float w) {
	float d = step(x-w*0.5, s) - step(x+w*0.5, s);
	return clamp(d, 0, 1);
}

void fragment() {
	float x = UV.x + sin(UV.y * 2.0 * PI) * 0.1;
	vec3 color = vec3(stroke(x, 0.5, 0.12));
	color += vec3(stroke(x, 0.25, 0.12));
	color += vec3(stroke(x, 0.75, 0.12));
	COLOR = vec4(color, 1);
}
