## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
class_name GatoControlScheme
extends InputConfig

@export var toggle_joystick: bool = false
@export var input_actions: Array[InputAction] = []

func _init(_name: String = "Custom") -> void:
	super(_name)

func get_as_dict() -> Dictionary:
	return {
		"type": "control_scheme",
		"name": name,
		"toggle_joystick": toggle_joystick,
		"input_actions": input_actions.map(func(it): return it.get_as_dict()),
	}

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

static func new_from_dict(dict: Dictionary) -> InputConfig:
	if dict["type"] != "control_scheme":
		push_error("Tried to initialize a control scheme with values that aren't of type 'control_scheme'.")
		return
	var instance: GatoControlScheme = new()
	instance.name = dict["name"]
	instance.toggle_joystick = dict["toggle_joystick"]
	instance.input_actions = load_input_actions(dict["input_actions"])
	return instance

static var type_to_script_map: Dictionary[String, Script] = {
	"input_action_button": load("res://addons/gato_input_remapper/model/input_action_button.gd"),
	"input_action2d_joystick": load("res://addons/gato_input_remapper/model/joystick_input_action_2d.gd"),
	"input_action2d_keys": load("res://addons/gato_input_remapper/model/keys_input_action_2d.gd"),
}

static func load_input_actions(input_actions: Array) -> Array[InputAction]:
	var loaded_input_actions: Array[InputAction] = []
	for input_action in input_actions:
		var script := type_to_script_map[input_action["type"]]
		loaded_input_actions.append(script.new_from_dict(input_action))
	return loaded_input_actions
