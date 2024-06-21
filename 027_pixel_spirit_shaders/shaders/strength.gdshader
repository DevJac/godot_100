shader_type canvas_item;

void fragment() {
	vec3 color = vec3(step(0.5, UV.x + sin(UV.y * 2.0 * PI) / 4.0));
	COLOR = vec4(color, 1);
}
