## GATO (Godot Accessibility TOolkit)

This is a collection of demos, documentation and plugins that aims to make implementing accessibility features easier for Godot games.

## Demos

Each demo contains a **minigame with accessibility issues**. They define the issue and explain what makes it inaccessible by **simulating the experience** of a person that suffers that inaccessibility. Each demo has a number of settings, which you will be able to tweak during the gameplay to try the limitations. That way you can build an intuition of how players feel while playing the game.

Afterwards, a **solution** for that issue will be shown and explained: why does it help and how does it work? Also, this project will be **open sourced**, so our aim is for you to be able to copy and paste the code into your project. Re-using it makes it **easier for you to implement**!

### List of demos

The first version of this collection of demos contains 5 demos:

* **Control Personalization:** Change how you control the characters with an input remapper and feed all the boards.
* **HUD Personalization:** Move the HUD around until it's comfortable for you, then guide the boars to their enclosure.
* **Text-to-Speech:** Overcome hard-to-read interfaces with the Text-to-Speech feature while you fight to get your acorns back!
* **High Contrast:** Turn the High Contrast mode on to find and collect all the golden acorns.
* **Color Blindness Filters:** Double check your gameplay doesn't depend on colors to work. Feed boars with theis favorite acorns.

## How to add a new demo

1. Create a new scene .tscn (or duplicate an existing one to start with the basic nodes).
2. Open `demo_selector.tscn` and access a node called "DemoContainer".
3. Access the "Demo" Array inside Demo List Resource (`demo_list.tres`) .
4. Click on "Add Element", add new `DemoData`.
5. Add a title, a description, an image cover and drag your created .tscn to "Scene".

You should now be able to see your created demo on the demo list and play it by clicking on it.

Each demo includes a pause menu and a completed demo menu that you can reuse in the new one you've created.

## Licensing and legal

This project has 3 parts, each with its own legal terms:

* **Source code**: all code located in the `/modules`, `/addons/gato_screen_filters` and `/addons/input_remapper` is licensed under the [MPL 2.0 license](./LICENSE.md).
* **Graphic assets**: all logos, icons, 3D models and other graphic assets located under `/modules`, `/addons/gato_screen_filters` and `/addons/input_remapper` are licensed under the [Creative Commons Attribution-ShareAlike 4.0 International License (CC BY-SA 4.0)](https://creativecommons.org/licenses/by-sa/4.0/).
* **Trademarks**: the project name "GATO (Godot Accessibility Toolkit)" and the project logo are trademarks of Iseltec S.L. This copyright license does not grant you any right to use these trademarks. As a general rule, you may use the name to refer to the project (e.g., "this game uses the plugin 'GATO: Input Remapper'") but you may not use the logo or imply endorsement. For any doubt, contact info@iseltec.com.
