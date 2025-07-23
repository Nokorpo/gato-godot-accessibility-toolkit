extends RefCounted

var action_name: StringName
var input: InputEvent

var category: StringName

func _init(
		_action_name: StringName, _input: InputEvent,
		_category: StringName = ""
	) -> void:
	action_name = _action_name
	input = _input
	category = _category

func get_category() -> StringName:
	return category

func apply_config() -> void:
	if not InputMap.has_action(action_name):
		printerr("Tried to remap action %s with GATO, but the action %s does not exist in the project's Input Map" % [action_name, action_name])
		return
	# TODO just generate a list of action -> input and return it
	# actually handling the inputmap should happen in a service
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, input)

func get_as_dict() -> Dictionary:
	return {
		"type": "input_action",
		"action_name": action_name,
		"category": category,
		"input_key": JSON.stringify(JSON.from_native(input, true))
	}

static func new_from_dict(dict: Dictionary) -> RefCounted:
	if dict["type"] != "input_action":
		printerr("Tried to initialize an input action with values that aren't of type 'input_action'.")
		return
	var input = JSON.to_native(JSON.parse_string(dict["input_key"]), true)
	return new(dict["action_name"], input, dict["category"])
