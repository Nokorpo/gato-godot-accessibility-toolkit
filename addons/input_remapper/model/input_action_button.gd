## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
class_name InputActionButton
extends InputAction

@export var input: InputEvent

func _init(
		_action_name: StringName = "input_action",
		_input: InputEvent = InputEventKey.new(),
		_category: StringName = ""
	) -> void:
	super(_action_name, _category)
	input = _input

func apply_config() -> void:
	if not InputMap.has_action(name):
		push_error("Tried to remap action %s with GATO Input Remapper, but the action %s does not exist in the project's Input Map" % [name, name])
		return
	# TODO just generate a list of action -> input and return it
	# actually handling the inputmap should happen in a service
	InputMap.action_erase_events(name)
	InputMap.action_add_event(name, input)

func equals(other_action: InputAction) -> bool:
	if other_action is not InputActionButton:
		return false
	if name != other_action.name:
		return false
	if input.keycode != other_action.input.keycode:
		return false
	return true

func contains_input_event(input_event: InputEvent) -> bool:
	return input.is_match(input_event)

func get_as_dict() -> Dictionary:
	return {
		"type": "input_action_button",
		"name": name,
		"category": category,
		"input_key": JSON.stringify(JSON.from_native(input, true))
	}

static func new_from_dict(dict: Dictionary) -> InputAction:
	if dict["type"] != "input_action_button":
		push_error("Tried to initialize an input action with values that aren't of type 'input_action'.")
		return
	var input = JSON.to_native(JSON.parse_string(dict["input_key"]), true)
	return new(dict["name"], input, dict["category"])
