extends GutTest

class Helper:
	static func create_input_event(key: int) -> InputEvent:
		var input_event := InputEventKey.new()
		input_event.keycode = key
		return input_event

	static func initialize_directional_input(action_base_name: String):
		for direction in ["up", "down", "left", "right"]:
			var action_name := "%s_%s" % [action_base_name, direction]
			InputMap.add_action(action_name)

	const ACTION_NAME := "act"
	const CATEGORY := "test"
	static func create_scheme() -> GatoControlScheme:
		var input_action = load("res://addons/input_remapper/model/input_action.gd")\
			.new(ACTION_NAME, create_input_event(KEY_0), CATEGORY)
		var input_action_2d = load("res://addons/input_remapper/model/input_action_2d.gd")\
			.new(ACTION_NAME, CATEGORY)
		input_action_2d.use_joystick(false, false)

		var scheme := GatoControlScheme.new()
		scheme.input_actions.append(input_action)
		scheme.input_actions.append(input_action_2d)
		return scheme

	static func create_input_config_json() -> Dictionary:
		var scheme := create_scheme()
		return { "control_schemes": [scheme.get_as_dict()] }

	static func check_scheme(scheme: Variant, test: GutTest):
		var input_action = scheme.input_actions[0]
		test.assert_not_null(input_action)
		test.assert_eq(input_action.input.keycode, KEY_0)
		var input_action_2d = scheme.input_actions[1]
		test.assert_not_null(input_action_2d)
		test.assert_eq(input_action_2d.input_map_config.invert_joystick, false)
		test.assert_eq(input_action_2d.input_map_config.use_right_joystick, false)

class TestInputRemapper extends GutTest:
	var sut := load("res://addons/input_remapper/service/input_remapper_service.gd")

# test can create and has storage_service instance
# test_apply_config
# test load_next
# test load_previous
# test reset


	#func test_load() -> void:
		#var json := Helper.create_input_config_json()
#
		#var storage_service = sut.new()
		#var schemes: Array[GatoControlScheme] = storage_service.load_input_config_from_json(json)
#
		#assert_not_null(schemes)
		#assert_gt(schemes.size(), 0, "Scheme array is empty")
		#assert_not_null(schemes[0], "Scheme is null")
		#Helper.check_scheme(schemes[0], self)
