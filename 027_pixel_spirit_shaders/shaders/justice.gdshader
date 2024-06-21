shader_type canvas_item;

void fragment() {
	vec3 color = vec3(0);
	vec2 st = UV;
	color += step(0.5, st.x);
	COLOR = vec4(color, 1);
}
