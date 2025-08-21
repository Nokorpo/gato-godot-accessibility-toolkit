shader_type canvas_item;
render_mode blend_mix;

uniform sampler2D mask;
uniform float horizontal_speed = 1.;
uniform float vertical_speed = 1.;

void fragment() {
	COLOR = texture(TEXTURE, vec2(UV.x - TIME * horizontal_speed, UV.y + 0.5 * sin(TIME * vertical_speed)));
	COLOR.a = texture(mask, SCREEN_UV).r;
}
