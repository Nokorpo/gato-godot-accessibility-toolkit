# GATO: Input Remapper

This plugin is a tool that allows players to customize the Input Map while playing.

It allows players that use special controllers to play your games more comfortably, and in some cases it might allow them to play when they couldn't have otherwise.

## Usage example

### Create the config file

The first thing we need to do to configure the Input Remapper is to create its configuration file.
This is a file that tells the plugin what actions we have in our game and what inputs are associated
wit them. It is usually stored in `user://input.data`.

The config file contains a set of **schemes**, which contain the action to input definitions. Think
of schemes as "presets" for different players. In our demo, we have presets for controlling the game
with a controller and a single hand, for instance.

The way to set up this config file up is a bit of a placeholder at the moment. You can create a
Resource of type GatoControlScheme and use the `InputRemapper.save_changes()` to store it in a file.

```gdscript
@tool

@export var schemes: Array[GatoControlScheme]
@export_tool_button("Save config") var save_config_button: Callable = func():
	InputRemapper.control_schemes = schemes
	InputRemapper.save_changes()
```

This will store the file in `user://input.data`, so be sure to make a copy of it if you want to set
it as a default for your game.

### Setting up the UI

You have already created the configuration file and you can see that InputRemapper loads it when the
game starts. Great! That's half the work! But now we need to set up the UI that the player will use
while the game is running.

We have a scene that you can use as an example in `res://addons/gato_input_remapper/ui/input_remapper_ui.tscn`.
It uses nodes for each type of action, like `2d_input_map.tscn` for 2D actions, which lets you select
between using buttons or a joystick. Or the `action_container.tscn`, which generates buttons for each
single button action in a category. It also contains error highlighting and save options.

You can re-use these elements or even the whole layout if you want. By changing its theme you can adapt
it to your game's look.

If you want to implement your own UI, the InputRemapper autoload has signals that are emitted when
the config is changed by the user and saved to a file (`InputRemapper.control_scheme_saved_to_file`)
and when a new control scheme is selected (`InputRemapper.control_scheme_changed`). You can also
access the currently loaded control schemes through the `InputRemapper.control_schemes` property.

## How it works

Input Remapper defines a model based on InputActions. These can be:
- InputActionButton: represents a single button press. The button can be accessed through the
	`InputActionButton.input.keycode` property.
- InputAction2D: represents a 2D interaction, either `KeysInputAction2D` for 4 buttons or
	`JoystickInputAction2D` for a joystick. The buttons or joysticks used can be accessed through the
	`get_map()` method, which returns a `Dictionary[StringName, InputEvent]` where the keys are
	directions `"up"`, `"down"`, `"left"` and `"right"`.

These are stored in the `input.data` file as a JSON and have multiple methods that can be useful, like:
	- `equals(other: InputAction)` to check if 2 InputActions are the same.
	- `contains_input_event(input_event: InputEvent)` to check if a particular Key or event is used
		by this InputAction.

-----------

This plugin is part of [GATO (Godot Accessibility Toolkit)](https://github.com/Nokorpo/gato-godot-accessibility-toolkit).
