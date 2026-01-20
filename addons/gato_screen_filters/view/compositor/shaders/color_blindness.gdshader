shader_type canvas_item;
/**
Shader script based on Alan Zucconi's blog post "Accessibility Design: Color
Blindness". Link: https://www.alanzucconi.com/2015/12/16/color-blindness/
*/

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
uniform int type: hint_range(0, 8) = 0;

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

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	vec4 screen = texture(screen_texture, SCREEN_UV);
	ColorWeightForChannel weight = color_translation[type];
	COLOR.r = weight.r.r * screen.r + weight.r.g * screen.g + weight.r.b * screen.b;
	COLOR.g = weight.g.r * screen.r + weight.g.g * screen.g + weight.g.b * screen.b;
	COLOR.b = weight.b.r * screen.r + weight.b.g * screen.g + weight.b.b * screen.b;
}
