class_name KeysInputAction2D
extends InputAction

enum Direction { UP, DOWN, LEFT, RIGHT }

@export var up: InputEventKey
@export var down: InputEventKey
@export var left: InputEventKey
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

func get_map() -> Dictionary[StringName, InputEvent]:
	return { "up": up, "down": down, "left": left, "right": right }

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

func apply_config() -> void:
	var input_map: Dictionary[StringName, InputEvent] = get_map()
	for direction: StringName in Direction.keys():
		var direction_action := "%s_%s" % [name, direction.to_lower()]
		if not InputMap.has_action(direction_action):
			printerr("Tried to remap action %s with GATO, but the action %s does not exist in the project's Input Map" % [direction_action, direction_action])
			return
		# TODO just generate a list of action -> input and return it
		# actually handling the inputmap should happen in a service
		InputMap.action_erase_events(direction_action)
		InputMap.action_add_event(direction_action, input_map[direction.to_lower()])

static func new_from_dict(dict: Dictionary) -> InputAction:
	if dict["type"] != "input_action2d_keys":
		printerr("Tried to initialize an input action 2d with values that aren't of type 'input_action2d_keys' or 'input_action2d_joystick'.")
		return

	var _up: InputEventKey = JSON.to_native(JSON.parse_string(dict["up"]), true)
	var _down: InputEventKey = JSON.to_native(JSON.parse_string(dict["down"]), true)
	var _left: InputEventKey = JSON.to_native(JSON.parse_string(dict["left"]), true)
	var _right: InputEventKey = JSON.to_native(JSON.parse_string(dict["right"]), true)

	return new(dict["name"], _up, _down, _left, _right, dict["category"])
