## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
##
## This class is the specific implementation of a control scheme, a set of pre-configured inputs and
## actions that can be used to offer default controls for players. We support defining multiple
## control schemes so that you can offer multiple default controls, based for instance on whether a
## player can use some keys or not. Some players can only use a hand (either left or right), while
## others struggle with joysticks or shoulder/trigger buttons, so it's a good idea to offer
## alternative controls for each type of player.
@tool
class_name GatoControlScheme
extends InputConfig

## The list of InputActions defined inside this ControlScheme.
@export var input_actions: Array[InputAction] = []

func _init(_name: String = "Custom") -> void:
	super(_name)

## Checks if the passed InputAction has the same value as the current instance. Returns true if so,
## false otherwise.
func equals(other_scheme: GatoControlScheme) -> bool:
	if self == other_scheme:
		return true

	if input_actions.size() != other_scheme.input_actions.size():
		return false

	var has_matches: Dictionary = {}
	for action in input_actions:
		has_matches[action] = false

	for action in input_actions:
		for other_action in other_scheme.input_actions:
			if action.equals(other_action):
				has_matches[action] = true
				break

	if has_matches.values().any(func(it): return it == false):
		return false
	return true

## Method used for serialization. When saving a control scheme to a file, it is first turned into a
## Dictionary with the data it needs (category, name, configuration...) so it can be stored as a
## JSON file. The configuration might include the InputEvent object that triggers the action.
func get_as_dict() -> Dictionary:
	return {
		"type": "control_scheme",
		"name": name,
		"input_actions": input_actions.map(func(it): return it.get_as_dict()),
	}

## Method used for deserialization. When loading a control scheme from a file, new instances of
## InputAction classes are created with the configuration from the stored JSON file. This method
## uses the data in those JSON objects to create a new instance of the InputAction.
##
## The ControlScheme is used to define what input type correspond to what class in the addon scripts.
static func new_from_dict(dict: Dictionary) -> InputConfig:
	if dict["type"] != "control_scheme":
		push_error("Tried to initialize a control scheme with values that aren't of type 'control_scheme'.")
		return
	var instance: GatoControlScheme = new()
	instance.name = dict["name"]
	instance.input_actions = load_input_actions(dict["input_actions"])
	return instance

## A Dictionary that maps InputAction type strings to the specific scripts
## holding their class implementation.
static var type_to_script_map: Dictionary[String, Script] = {
	"input_action_button": load("res://addons/gato_input_remapper/model/input_action_button.gd"),
	"input_action2d_joystick": load("res://addons/gato_input_remapper/model/joystick_input_action_2d.gd"),
	"input_action2d_keys": load("res://addons/gato_input_remapper/model/keys_input_action_2d.gd"),
}

## This method is used during the creation of a new ControlScheme object from a Dictionary (see the
## `new_from_dict()` method). It receives the lis of InputActions from the stored JSON configuration
## and converts it to ready-to-use objects from the addons scripts.
static func load_input_actions(input_actions: Array) -> Array[InputAction]:
	var loaded_input_actions: Array[InputAction] = []
	for input_action in input_actions:
		var script := type_to_script_map[input_action["type"]]
		loaded_input_actions.append(script.new_from_dict(input_action))
	return loaded_input_actions
