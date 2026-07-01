## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
##
## This class is specific configuration that maps a button input to an action. This is a
## 0-dimensional/boolean input: either the button is pressed or not.
@tool
class_name InputActionButton
extends InputAction

## Godot InputEvent that will trigger this action.
@export var input: InputEvent

func _init(
		_action_name: StringName = "input_action",
		_input: InputEvent = InputEventKey.new(),
		_category: StringName = ""
	) -> void:
	super(_action_name, _category)
	input = _input

## If you want to use an InputAction, this is the method to call. This method tells the InputAction
## to call Godot's Input API to configure itself there. For concrete actions, this means creating an
## action on the InputMap and assigning the input to it, for schemes or group of actions this means
## applying each InputAction individually.
func apply_config() -> void:
	if not InputMap.has_action(name):
		push_error("Tried to remap action %s with GATO Input Remapper, but the action %s does not exist in the project's Input Map" % [name, name])
		return
	# TODO just generate a list of action -> input and return it
	# actually handling the inputmap should happen in a service
	InputMap.action_erase_events(name)
	InputMap.action_add_event(name, input)

## Checks if the passed InputAction has the same value as the current instance. Returns true if so,
## false otherwise.
func equals(other_action: InputAction) -> bool:
	if other_action is not InputActionButton:
		return false
	if name != other_action.name:
		return false
	if input.keycode != other_action.input.keycode:
		return false
	return true

## Checks if the InputAction uses the parameter InputEvent in any way.
##
## This method is used to know if there are conflicting inputs (inputs used for multiple actions) in
## the current scheme. This then is used to warn the player about this conflict.
func contains_input_event(input_event: InputEvent) -> bool:
	return input.is_match(input_event)

## Method used for serialization. When saving a control scheme to a file, it is first turned into a
## Dictionary with the data it needs (category, name, configuration...) so it can be stored as a
## JSON file. The configuration might include the InputEvent object that triggers the action.
func get_as_dict() -> Dictionary:
	return {
		"type": "input_action_button",
		"name": name,
		"category": category,
		"input_key": JSON.stringify(JSON.from_native(input, true))
	}

## Method used for deserialization. When loading a control scheme from a file, new instances of
## InputAction classes are created with the configuration from the stored JSON file. This method
## uses the data in those JSON objects to create a new instance of the InputAction.
static func new_from_dict(dict: Dictionary) -> InputAction:
	if dict["type"] != "input_action_button":
		push_error("Tried to initialize an input action with values that aren't of type 'input_action'.")
		return
	var input = JSON.to_native(JSON.parse_string(dict["input_key"]), true)
	return new(dict["name"], input, dict["category"])
