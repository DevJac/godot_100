shader_type canvas_item;

uniform vec2 resolution;

void fragment() {
	vec2 st = UV * 2.0 - vec2(1, 1);
	st.x *= resolution.x / resolution.y;
	vec3 color = vec3(step(st.y, st.x));
	COLOR = vec4(color, 1);
}
 