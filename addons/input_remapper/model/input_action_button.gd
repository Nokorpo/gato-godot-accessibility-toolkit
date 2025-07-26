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
