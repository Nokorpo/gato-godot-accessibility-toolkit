class_name JoystickInputAction2D
extends InputAction

enum Direction { UP, DOWN, LEFT, RIGHT }

@export var use_right_joystick: bool = false
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

func get_as_dict() -> Dictionary:
	return {
		"type": "input_action2d_joystick",
		"use_right_joystick": use_right_joystick,
		"invert_joystick": invert_joystick,
		"name": name,
		"category": category
	}

static func new_from_dict(dict: Dictionary) -> InputAction:
	if dict["type"] != "input_action2d_joystick":
		push_error("Tried to initialize an input action 2d with values that aren't of type 'input_action2d_keys' or 'input_action2d_joystick'.")
		return

	return new(dict["name"], dict["use_right_joystick"], dict["invert_joystick"], dict["category"])
