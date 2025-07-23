class_name GatoControlScheme
extends RefCounted

var name: StringName = "Custom"
var toggle_joystick: bool = false
var input_actions: Array = []

func get_as_dict() -> Dictionary:
	return {
		"type": "control_scheme",
		"toggle_joystick": toggle_joystick,
		"input_actions": input_actions.map(func(it): return it.get_as_dict()),
	}

static func new_from_dict(dict: Dictionary) -> GatoControlScheme:
	if dict["type"] != "control_scheme":
		printerr("Tried to initialize a control scheme with values that aren't of type 'control_scheme'.")
		return
	var instance: GatoControlScheme = new()
	instance.toggle_joystick = dict["toggle_joystick"]
	instance.input_actions = load_input_actions(dict["input_actions"])
	return instance

static var type_to_script_map: Dictionary[String, Script] = {
	"input_action": load("res://addons/input_remapper/model/input_action.gd"),
	"input_action2d": load("res://addons/input_remapper/model/input_action_2d.gd")
}

static func load_input_actions(input_actions: Array) -> Variant:
	var loaded_input_actions := []
	for input_action in input_actions:
		var script := type_to_script_map[input_action["type"]]
		loaded_input_actions.append(script.new_from_dict(input_action))
	return loaded_input_actions
