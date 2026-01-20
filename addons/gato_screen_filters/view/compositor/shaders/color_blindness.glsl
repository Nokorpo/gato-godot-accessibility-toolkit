#[compute]
#version 450

// Invocations in the (x, y, z) dimension
layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

layout(rgba16f, set = 0, binding = 0) uniform image2D color_image;

// Our push constant
layout(push_constant, std430) uniform Params {
	/**
	Selects the type of color blindness filter to apply. The numbers translate to the following:

	0 = Normal vision (92% of people)
	1 = Protanopia    (0.59% of people)
	2 = Protanomaly   (0.66% of people)
	3 = Deuteranopia  (0.56% of people)
	4 = Deuteranomaly (2.7% of people)
	5 = Tritanopia    (0.016% of people)
	6 = Tritanomaly   (0.01% of people)
	7 = Achromatopsia (<0.001% of people)
	8 = Achromatomaly (<0.001% of people)
	*/
	int color_blindness_type;
} params;

/**
Shader script based on Alan Zucconi's blog post "Accessibility Design: Color
Blindness". Link: https://www.alanzucconi.com/2015/12/16/color-blindness/
*/



/**
Represents how much each color weights in the final mix for each color channel. Each variable
represents how much Red, Green and Blue from the original image is in the final r, g and b channels.
*/
struct ColorWeightForChannel {
    vec3 r;
    vec3 g;
    vec3 b;
};

/**
Represents a translation matrix that defines how much of the original image's Red, Green and Blue is
in each color channel of the new image.
*/
const ColorWeightForChannel color_translation[9] = {
	// Channel:           red                       green                     blue
	ColorWeightForChannel(vec3(1.0, .0, .0),        vec3(.0, 1.0, .0),        vec3(.0, .0, 1.0)),        // Normal vision (92% of people)
	ColorWeightForChannel(vec3(.56667, .43333, .0), vec3(.55833, .44167, .0), vec3(.0, .24167, .75833)), // Protanopia    (0.59% of people)
	ColorWeightForChannel(vec3(.81667, .18333, .0), vec3(.33333, .66667, .0), vec3(.0, .125, .875)),     // Protanomaly   (0.66% of people)
	ColorWeightForChannel(vec3(.624, .375, .0),     vec3(.70, .30, .0),       vec3(.0, .30, .70)),       // Deuteranopia  (0.56% of people)
	ColorWeightForChannel(vec3(.80, .20, .0),       vec3(.0, .25833, .74167), vec3(.0, .14167, .85833)), // Deuteranomaly (2.7% of people)
	ColorWeightForChannel(vec3(.95, .05, .0),       vec3(.0, .43333, .56667), vec3(.0, .475, .525)),     // Tritanopia    (0.016% of people)
	ColorWeightForChannel(vec3(.96667, .03333, .0), vec3(.0, .73333, .26667), vec3(.0, .18333, .81667)), // Tritanomaly   (0.01% of people)
	ColorWeightForChannel(vec3(.299, .587, .114),   vec3(.299, .587, .114),   vec3(.299, .587, .114)),   // Achromatopsia (<0.001% of people)
	ColorWeightForChannel(vec3(.618, .32, .062),    vec3(.163, .775, .062),   vec3(.163, .32, .516))     // Achromatomaly (<0.001% of people)
};

// The code we want to execute in each invocation
void main() {
	ivec2 uv = ivec2(gl_GlobalInvocationID.xy);
	/*ivec2 size = ivec2(params.raster_size);

	// Prevent reading/writing out of bounds.
	if (uv.x >= size.x || uv.y >= size.y) {
		return;
	}*/

	// Read from our color buffer.
	vec4 color = imageLoad(color_image, uv);

	// Apply our changes.
	// float gray = color.r * 0.2125 + color.g * 0.7154 + color.b * 0.0721;
	// color.rgb = vec3(gray);

	ColorWeightForChannel weight = color_translation[params.color_blindness_type];

	color.r = weight.r.r * color.r + weight.r.g * color.g + weight.r.b * color.b;
	color.g = weight.g.r * color.r + weight.g.g * color.g + weight.g.b * color.b;
	color.b = weight.b.r * color.r + weight.b.g * color.g + weight.b.b * color.b;

	// Write back to our color buffer.
	imageStore(color_image, uv, color);
}