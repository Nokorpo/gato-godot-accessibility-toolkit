shader_type canvas_item;

uniform vec3 black_and_white_constant : source_color = vec3(.299, .587, .114);
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
		vec3 screen = textureLod(screen_texture, SCREEN_UV, 0.0).rgb;
		float gray = dot(screen, black_and_white_constant);
        COLOR = vec4(gray, gray, gray, 1.);
}