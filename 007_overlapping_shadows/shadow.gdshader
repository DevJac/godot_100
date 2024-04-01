shader_type canvas_item;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	tex_color.rgb = vec3(0.0);
	COLOR = tex_color;
}