
# Color blindness shader

We feels we need to make special mention of how the shader for color blindness works. Not because it's complex - the idea is very simple: take some amount of red, some of green, some of blue, then mix them together and show it on sccreen - but because the huge matrix of values can be intimidating. By understanding how it works, you should be able to change it in case you want to change some values or try different effects. Or if you just want to understand how it works.

## Color weight matrix

If you open the shader, you will see an intimidating wall of numbers and parenthesis. It might seem complex at first, but this is just a table storing values.

We defined a struct that represents how much each color weights in the final mix for each color channel. This struct contains three vec3 values: one for red, green and blue. Each of these vec3 tell how much of the original RGB colors (hence the vec3) will be on the final picture. This can be easily understood with an example:

In normal vision we get 1 of red for each red pixel on the screen, 1-to-1 for green and 1-to-1 for blue. How does this look with code?

```
# Normal vision
ColorWeightForChannel(
# original     r,   g,   b
        vec3(1.0, 0.0, 0.0), # final red
        vec3(0.0, 1.0, 0.0), # final green
        vec3(0.0, 0.0, 1.0), # final blue
);
```

But since the final red for protanopia is a mix of 56.67% red and 43.33% green, it will look like this:

```
# Protanopia
ColorWeightForChannel(
# original        r,      g,   b
        vec3(0.5667, 0.4333, 0.0), # final red
        // ...
);
```

## Changing colors on screen

Now that we have this handy transaltion matrix, we just need to consult it to decide the final color on the screen. This is very simple and can be done with a couple of lines. First we need to get a reference to the ColorWeightForChannel struct we want to use. Let's say we want to use the protanopia values:

```
ColorWeightForChannel protanopia_weights = ColorWeightForChannel(
        vec3(0.5667, 0.4333, 0.0),
        vec3(0.5583, 0.4417, 0.0),
        vec3(0.0, 0.2417, 0.7583)
);
```

After we have the reference, we just need to get the weight for each color and add it up. Then we can pass it to the final `COLOR` variable that will be rendered on screen:

```
float red = protanopia_weight.r.r * screen.r + protanopia_weight.r.g * screen.g + protanopia_weight.r.b * screen.b;

COLOR.r = red;
```

Then we just repeat this for green and blue and we're done!
