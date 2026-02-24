shader_type canvas_item;

uniform float speed = -0.005;

void vertex() {
	UV.x += TIME * speed;
	UV.y += TIME * speed;
}

void fragment() {
	COLOR.a = 1;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
