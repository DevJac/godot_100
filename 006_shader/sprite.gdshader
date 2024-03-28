shader_type canvas_item;

uniform float blue = 1.0;

void vertex() {
	VERTEX *= 1.0 + 0.1 * sin(TIME);
}

void fragment() {
	COLOR = vec4(UV, blue, 1) * (texture(TEXTURE, UV) * 2.0);
}
