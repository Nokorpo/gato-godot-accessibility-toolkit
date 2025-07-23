extends RefCounted

enum Direction { UP, DOWN, LEFT, RIGHT }

var input_map_config

var action_name: StringName
var category: StringName

func _init(_action_name: StringName, _category: StringName = "") -> void:
	action_name = _action_name
	category = _category

func use_keys(_up: InputEventKey, _down: InputEventKey, _left: InputEventKey, _right: InputEventKey) -> void:
	input_map_config = KeysInputMap.new(_up, _down, _left, _right)

func use_joystick(_use_right_joystick: bool = false, _invert_joystick: bool = false) -> void:
	input_map_config = JoystickInputMap.new(_use_right_joystick, _invert_joystick)

func get_category() -> StringName:
	return category

func apply_config() -> void:
	if input_map_config == null:
		printerr("Tried to apply action %s configuration without defining it first. Did you call either the \"use_joystick()\" or \"use_keys()\" method?" % action_name)
		return

	var input_map: Dictionary[StringName, InputEvent] = input_map_config.get_map()
	for direction: StringName in Direction.keys():
		var direction_action := "%s_%s" % [action_name, direction.to_lower()]
		if not InputMap.has_action(direction_action):
			printerr("Tried to remap action %s with GATO, but the action %s does not exist in the project's Input Map" % [direction_action, direction_action])
			return
		# TODO just generate a list of action -> input and return it
		# actually handling the inputmap should happen in a service
		InputMap.action_erase_events(direction_action)
		InputMap.action_add_event(direction_action, input_map[direction.to_lower()])

func get_as_dict() -> Dictionary:
	return {
		"type": "input_action2d",
		"action_name": action_name,
		"category": category,
		"input_map_config": input_map_config.get_as_dict()
	}

static func new_from_dict(dict: Dictionary) -> Variant:
	if dict["type"] != "input_action2d":
		printerr("Tried to initialize an input action 2d with values that aren't of type 'input_action2d_keys' or 'input_action2d_joystick'.")
		return

	var instance = new(dict["action_name"], dict["category"])
	var input: Dictionary = dict["input_map_config"]
	if input["type"] == "input_action2d_keys":
		instance.use_keys(input["up"],input["down"],input["left"],input["right"])
	elif input["type"] == "input_action2d_joystick":
		instance.use_joystick(input["use_right_joystick"], input["invert_joystick"])
	else:
		printerr("Trying to load an input map config with an unknown type.")
		return
	return instance

class KeysInputMap:
	var up: InputEventKey
	var down: InputEventKey
	var left: InputEventKey
	var right: InputEventKey

	func _init(_up: InputEventKey, _down: InputEventKey, _left: InputEventKey, _right: InputEventKey) -> void:
		up = _up
		down = _down
		left = _left
		right = _right

	func get_map() -> Dictionary[StringName, InputEvent]:
		return { "up": up, "down": down, "left": left, "right": right }

	func get_as_dict() -> Dictionary:
		return {
			"type": "input_action2d_keys",
			"up": up,
			"down": down,
			"left": left,
			"right": right
		}

class JoystickInputMap:
	var invert_joystick: bool = false
	var use_right_joystick: bool = false

	func _init(_use_right_joystick: bool = false, _invert_joystick: bool = false) -> void:
		use_right_joystick = _use_right_joystick
		invert_joystick = _invert_joystick

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

	func get_as_dict() -> Dictionary:
		return {
			"type": "input_action2d_joystick",
			"use_right_joystick": use_right_joystick,
			"invert_joystick": invert_joystick
		}
