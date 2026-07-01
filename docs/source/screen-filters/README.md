# GATO: Screen Filters

This plugin is a plug-and-play tool for developers to see their games through the eyes of players
with different types of vision impairments and to provide tools that help these players play these games.

## Color blindness

Some people have a reduced ability to distinguish certain colors, usually red and green. This is
commonly known as color blindness (Color Vision Deficiency, or CVD). This affects 2.59% of people
around the globe ([citation](https://www.sciencedirect.com/science/article/abs/pii/S0161642025004658)),
roughly 1 in every 22 men and 1 in 200 women. It happens even more frequently on people of European
descent, with roughly 1 in every 12 men (8%) and 1 in every 200 women.

| Population      | Affected (%) |
| --------------- | ------------ |
| Global          | 2.59 %       |
| Global (male)   | 4.38 %       |
| Global (female) | 0.64 %       |
| European descent (male) | ~8 % |

### What does this mean for videogames?

It means that players miss visual cues such as enemy highlights,
health bars, loot rarity tiers, or environmental puzzles. If you rely just on colors, some people
just won't be able to see them, which can result in a bad experience and even in unplayable games in
the most extreme cases.

### Then, what can we do about it?

We can design our games so that they can be played even with reduced colors. What this plugin does
is just that: it's a debug tool for game developers to see their games like color blind people would.

## How it works

> #### ⚠️⚠️⚠️ BIG WARNING: ⚠️⚠️⚠️
> This is **not** meant as a "quick fix" for color blind players. Such thing doesn't exist. It's an
> aid for developers to see their game through the eyes of a color blind person and adapt it.

The way you use it is:

1. Press F6 while running your game to open the Screen Filters menu.
1. Enable one of the filters.
2. Play your game and try to notice where the UI/visuals are difficult to understand.
3. Then you change colors or add other features to adapt your graphics for color blindness.

-----------

This plugin is part of [GATO (Godot Accessibility Toolkit)](https://github.com/Nokorpo/gato-godot-accessibility-toolkit).
