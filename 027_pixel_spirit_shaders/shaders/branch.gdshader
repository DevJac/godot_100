shader_type canvas_item;

uniform vec2 resolution;

float stroke(float x, float s, float w) {
	float d = step(x-w*0.5, s) - step(x+w*0.5, s);
	return clamp(d, 0, 1);
}

void fragment() {
	vec2 st = UV * 2.0 - vec2(1, 1);
	st.x *= resolution.x / resolution.y;
	st.x *= -1.0;
	vec3 color = vec3(stroke(st.x - st.y, 0.0, 0.15));
	COLOR = vec4(color, 1);
}
