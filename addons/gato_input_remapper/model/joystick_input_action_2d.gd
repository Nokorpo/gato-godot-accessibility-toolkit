## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
##
## This class is specific configuration that maps a 2D input to an action. This is handled by
## creating 4 different actions, using the action's name and appending `_up`, `_down`, `_left` or
## `_right` to it. So, for instance, a "move" action will have the `move_up`, `move_down`,
## `move_left` and `move_right` actions created. In this case, those 4 directions are controlled
## with a joystick.
@tool
class_name JoystickInputAction2D
extends InputAction

## Directions used to map InputEvents to the right direction inside this class.
enum Direction { UP, DOWN, LEFT, RIGHT }

## This flag defines whether this InputAction uses the left joystick (false) or the right one (true).
@export var use_right_joystick: bool = false
## This flag defines whether this InputAction's vertical dimension is inverted or not. If false, up
## is negative and down is positive. If false, up is positive and down is negative.
@export var invert_joystick: bool = false

func _init(
		_name: StringName = "input_action",
		_use_right_joystick: bool = false,
		_invert_joystick: bool = false,
		_category: StringName = ""
	) -> void:
	super(_name, _category)
	use_right_joystick = _use_right_joystick
	invert_joystick = _invert_joystick

## Returns a Dictionary that maps directions (up, down, left, right) to specific InputEvents that
## trigger this action to "move" in that direction.
func get_map() -> Dictionary[StringName, InputEvent]:
	var joystick_up = InputEventJoypadMotion.new()
	joystick_up.axis = 2 if use_right_joystick else 0
	joystick_up.axis_value = -1 if invert_joystick else 1
	var joystick_down = InputEventJoypadMotion.new()
	joystick_down.axis = 2 if use_right_joystick else 0
	joystick_down.axis_value = 1 if invert_joystick else -1
	var joystick_left = InputEventJoypadMotion.new()
	joystick_left.axis = 3 if use_right_joystick else 1
	joystick_left.axis_value = -1
	var joystick_right = InputEventJoypadMotion.new()
	joystick_right.axis = 3 if use_right_joystick else 1
	joystick_right.axis_value = 1
	return { "up": joystick_up, "down": joystick_down, "left": joystick_left, "right": joystick_right }

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
	if other_action is not JoystickInputAction2D:
		return false
	if name != other_action.name:
		return false
	if use_right_joystick != other_action.use_right_joystick \
		or invert_joystick != other_action.invert_joystick:
		return false
	return true

## Checks if the InputAction uses the parameter InputEvent in any way.
##
## This method is used to know if there are conflicting inputs (inputs used for multiple actions) in
## the current scheme. This then is used to warn the player about this conflict.
func contains_input_event(input_event: InputEvent) -> bool:
	for input: InputEventKey in get_map().values():
		if input.is_match(input_event):
			return true
	return false

## Method used for serialization. When saving a control scheme to a file, it is first turned into a
## Dictionary with the data it needs (category, name, configuration...) so it can be stored as a
## JSON file. The configuration might include the InputEvent object that triggers the action.
func get_as_dict() -> Dictionary:
	return {
		"type": "input_action2d_joystick",
		"use_right_joystick": use_right_joystick,
		"invert_joystick": invert_joystick,
		"name": name,
		"category": category
	}

## Method used for deserialization. When loading a control scheme from a file, new instances of
## InputAction classes are created with the configuration from the stored JSON file. This method
## uses the data in those JSON objects to create a new instance of the InputAction.
static func new_from_dict(dict: Dictionary) -> InputAction:
	if dict["type"] != "input_action2d_joystick":
		push_error("Tried to initialize an input action 2d with values that aren't of type 'input_action2d_keys' or 'input_action2d_joystick'.")
		return

	return new(dict["name"], dict["use_right_joystick"], dict["invert_joystick"], dict["category"])
