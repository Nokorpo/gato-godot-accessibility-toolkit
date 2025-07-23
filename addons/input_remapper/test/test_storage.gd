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

class TestStorage extends GutTest:
	var sut := load("res://addons/input_remapper/service/storage_service.gd")

	func test_load() -> void:
		var json := Helper.create_input_config_json()

		var storage_service = sut.new()
		var schemes: Array[GatoControlScheme] = storage_service.load_input_config_from_json(json)

		assert_not_null(schemes)
		assert_gt(schemes.size(), 0, "Scheme array is empty")
		assert_not_null(schemes[0], "Scheme is null")
		Helper.check_scheme(schemes[0], self)

	const TEMP_FILE := "user://temp.txt"
	const FILE_CONTENTS := '{"control_schemes":[
		{"input_actions":[{"action_name":"act","category":"test","input_key":"{\\"props\\":[\\"resource_local_to_scene\\",false,\\"resource_name\\",\\"s:\\",\\"device\\",\\"i:0\\",\\"window_id\\",\\"i:0\\",\\"alt_pressed\\",false,\\"shift_pressed\\",false,\\"ctrl_pressed\\",false,\\"meta_pressed\\",false,\\"pressed\\",false,\\"keycode\\",\\"i:48\\",\\"physical_keycode\\",\\"i:0\\",\\"key_label\\",\\"i:0\\",\\"unicode\\",\\"i:0\\",\\"location\\",\\"i:0\\",\\"echo\\",false,\\"script\\",null],\\"type\\":\\"InputEventKey\\"}","type":"input_action"},{"action_name":"act","category":"test","input_map_config":{"invert_joystick":false,"type":"input_action2d_joystick","use_right_joystick":false},"type":"input_action2d"}],"toggle_joystick":false,"type":"control_scheme"},
		{"input_actions":[{"action_name":"act","category":"test","input_key":"{\\"props\\":[\\"resource_local_to_scene\\",false,\\"resource_name\\",\\"s:\\",\\"device\\",\\"i:0\\",\\"window_id\\",\\"i:0\\",\\"alt_pressed\\",false,\\"shift_pressed\\",false,\\"ctrl_pressed\\",false,\\"meta_pressed\\",false,\\"pressed\\",false,\\"keycode\\",\\"i:48\\",\\"physical_keycode\\",\\"i:0\\",\\"key_label\\",\\"i:0\\",\\"unicode\\",\\"i:0\\",\\"location\\",\\"i:0\\",\\"echo\\",false,\\"script\\",null],\\"type\\":\\"InputEventKey\\"}","type":"input_action"},{"action_name":"act","category":"test","input_map_config":{"invert_joystick":false,"type":"input_action2d_joystick","use_right_joystick":false},"type":"input_action2d"}],"toggle_joystick":false,"type":"control_scheme"}
		]}'
	func test_store() -> void:
		var input_config := Helper.create_scheme()

		var storage_service = sut.new()
		storage_service.store_input_config(input_config, TEMP_FILE)

		assert_file_exists(TEMP_FILE)
		var temp_file := FileAccess.open(TEMP_FILE, FileAccess.READ)
		assert_eq(FileAccess.get_file_as_string(TEMP_FILE), FILE_CONTENTS)

		DirAccess.remove_absolute(TEMP_FILE)

	func test_store_then_load():
		var input_config := Helper.create_scheme()

		var storage_service = sut.new()
		storage_service.store_input_config(input_config, TEMP_FILE)
		var schemes: Array[GatoControlScheme] = storage_service.load_input_config_from_file(TEMP_FILE)

		assert_not_null(schemes)
		assert_gt(schemes.size(), 0, "Scheme array is empty")
		assert_not_null(schemes[0], "Scheme is null")
		Helper.check_scheme(schemes[0], self)

		DirAccess.remove_absolute(TEMP_FILE)

# test has name
