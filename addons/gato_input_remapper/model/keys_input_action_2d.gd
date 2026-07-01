## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
##
## This class is specific configuration that maps a 2D input to an action. This is handled by
## creating 4 different actions, using the action's name and appending `_up`, `_down`, `_left` or
## `_right` to it. So, for instance, a "move" action will have the `move_up`, `move_down`,
## `move_left` and `move_right` actions created. In this case, those 4 directions are controlled
## with 4 different button presses (usually WASD or up, down, left and right keys).
@tool
class_name KeysInputAction2D
extends InputAction

## Directions used to map InputEvents to the right direction inside this class.
enum Direction { UP, DOWN, LEFT, RIGHT }

## Key that will trigger the up action (negative Y).
@export var up: InputEventKey
## Key that will trigger the down action (positive Y).
@export var down: InputEventKey
## Key that will trigger the left action (negative X).
@export var left: InputEventKey
## Key that will trigger the right action (positive X).
@export var right: InputEventKey

func _init(
		_name: StringName = "input_action",
		_up: InputEventKey = InputEventKey.new(),
		_down: InputEventKey = InputEventKey.new(),
		_left: InputEventKey = InputEventKey.new(),
		_right: InputEventKey = InputEventKey.new(),
		_category: StringName = ""
	) -> void:
	super(_name, _category)
	up = _up
	down = _down
	left = _left
	right = _right

## Returns a Dictionary that maps directions (up, down, left, right) to specific InputEvents that
## trigger this action to "move" in that direction.
func get_map() -> Dictionary[StringName, InputEvent]:
	return { "up": up, "down": down, "left": left, "right": right }

## If you want to use an InputAction, this is the method to call. This method tells the InputAction
## to call Godot's Input API to configure itself there. For concrete actions, this means creating an
## action on the InputMap and assigning the input to it, for schemes or group of actions this means
## applying each InputAction individually.
func apply_config() -> void:
	var input_map: Dictionary[StringName, InputEvent] = get_map()
	for direction: StringName in Direction.keys():
		var direction_action := "%s_%s" % [name, direction.to_lower()]
		if not InputMap.has_action(direction_action):
			push_error("Tried to remap action %s with GATO Input Remapper, but the action %s does not exist in the project's Input Map" % [direction_action, direction_action])
			return
		# TODO just generate a list of action -> input and return it
		# actually handling the inputmap should happen in a service
		InputMap.action_erase_events(direction_action)
		InputMap.action_add_event(direction_action, input_map[direction.to_lower()])

## Checks if the passed InputAction has the same value as the current instance. Returns true if so,
## false otherwise.
func equals(other_action: InputAction) -> bool:
	if other_action is not KeysInputAction2D:
		return false
	if name != other_action.name:
		return false
	if up.keycode != other_action.up.keycode \
		or down.keycode != other_action.down.keycode \
		or left.keycode != other_action.left.keycode \
		or right.keycode != other_action.right.keycode:
		return false
	return true

## Checks if the InputAction uses the parameter InputEvent in any way.
##
## This method is used to know if there are conflicting inputs (inputs used for multiple actions) in
## the current scheme. This then is used to warn the player about this conflict.
func contains_input_event(input_event: InputEvent) -> bool:
	for input: InputEventKey in [up, down, left, right]:
		if input.is_match(input_event):
			return true
	return false

## Method used for serialization. When saving a control scheme to a file, it is first turned into a
## Dictionary with the data it needs (category, name, configuration...) so it can be stored as a
## JSON file. The configuration might include the InputEvent object that triggers the action.
func get_as_dict() -> Dictionary:
	return {
		"type": "input_action2d_keys",
		"name": name,
		"category": category,
		"up": JSON.stringify(JSON.from_native(up, true)),
		"down": JSON.stringify(JSON.from_native(down, true)),
		"left": JSON.stringify(JSON.from_native(left, true)),
		"right": JSON.stringify(JSON.from_native(right, true))
	}

## Method used for deserialization. When loading a control scheme from a file, new instances of
## InputAction classes are created with the configuration from the stored JSON file. This method
## uses the data in those JSON objects to create a new instance of the InputAction.
static func new_from_dict(dict: Dictionary) -> InputAction:
	if dict["type"] != "input_action2d_keys":
		push_error("Tried to initialize an input action 2d with values that aren't of type 'input_action2d_keys' or 'input_action2d_joystick'.")
		return

	var _up: InputEventKey = JSON.to_native(JSON.parse_string(dict["up"]), true)
	var _down: InputEventKey = JSON.to_native(JSON.parse_string(dict["down"]), true)
	var _left: InputEventKey = JSON.to_native(JSON.parse_string(dict["left"]), true)
	var _right: InputEventKey = JSON.to_native(JSON.parse_string(dict["right"]), true)

	return new(dict["name"], _up, _down, _left, _right, dict["category"])
