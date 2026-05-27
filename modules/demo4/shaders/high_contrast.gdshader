shader_type spatial;

uniform vec3 color: source_color = vec3(1., 1., 1.);
uniform float highlight_force = 1.;

void fragment() {
	FOG = -FOG * highlight_force;
	float strength = (COLOR.r * 0.299 + COLOR.g * 0.587 + COLOR.b * 0.114)/3.;
	ALBEDO = vec3(strength * color);
}
