## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends GutTest

class Helper:
	const ACTION_NAME := "act"
	const CATEGORY := "test"
	const TEMP_FILE := "user://temp.txt"

	static func create_input_event(key: int) -> InputEvent:
		var input_event := InputEventKey.new()
		input_event.keycode = key
		return input_event

	static func create_scheme() -> GatoControlScheme:
		var input_action = load("res://addons/gato_input_remapper/model/input_action_button.gd")\
			.new(ACTION_NAME, create_input_event(KEY_0), CATEGORY)

		var scheme := GatoControlScheme.new()
		scheme.input_actions.append(input_action)
		return scheme

	static func create_input_config_json() -> Dictionary:
		var scheme := create_scheme()
		return { "control_schemes": [scheme.get_as_dict()] }

	static func create_empty_schemes() -> Array[GatoControlScheme]:
		var scheme_list: Array[GatoControlScheme] = []
		var names := ["one", "two", "three"]
		for name in names:
			var scheme := GatoControlScheme.new()
			scheme.name = name
			scheme_list.append(scheme)
		return scheme_list

	static func generate_file_content() -> String:
		var storage = load("res://addons/gato_input_remapper/service/storage_service.gd").new()
		storage.store_input_config(Helper.create_empty_schemes(), TEMP_FILE)
		var text := FileAccess.get_file_as_string(TEMP_FILE)
		DirAccess.remove_absolute(TEMP_FILE)
		return text

class TestInputRemapper extends GutTest:
	var sut := load("res://addons/gato_input_remapper/service/input_remapper_service.gd")

	func test_autoload_initializes_storage_service() -> void:
		var input_remapper_autoload = InputRemapper
		assert_not_null(input_remapper_autoload, "Autoload does not exist. Is the plugin enabled?")
		assert_true("storage_service" in input_remapper_autoload)
		assert_not_null(input_remapper_autoload.storage_service, "The autoload didn't initialize the storage service")

	func test_config_is_applied() -> void:
		InputMap.add_action(ACTION_NAME)
		var scheme := Helper.create_scheme()
		var input_remapper = sut.new()
		input_remapper.control_schemes = [scheme] as Array[GatoControlScheme]

		input_remapper.load_next_scheme()

		assert_true(InputMap.has_action(ACTION_NAME), "The action was not set")
		var events := InputMap.action_get_events("act")
		assert_gt(events.size(), 0, "The action has no inputs")
		input_remapper.free()
		InputMap.erase_action(ACTION_NAME)

	func test_load_next_works() -> void:
		var schemes := Helper.create_empty_schemes()
		var input_remapper = sut.new()
		input_remapper.control_schemes = schemes

		input_remapper.load_next_scheme()

		assert_eq(input_remapper.get_current_scheme().name, "two")
		input_remapper.free()

	func test_load_previous_works() -> void:
		var schemes := Helper.create_empty_schemes()
		var input_remapper = sut.new()
		input_remapper.control_schemes = schemes

		input_remapper.load_previous_scheme()

		assert_eq(input_remapper.get_current_scheme().name, "three")
		input_remapper.free()

	const ACTION_NAME := "act"
	const TEMP_FILE := "user://temp.txt"
	const FILE_CONTENT := '{"control_schemes":[{"input_actions":[],"name":"one","toggle_joystick":false,"type":"control_scheme"},{"input_actions":[],"name":"two","toggle_joystick":false,"type":"control_scheme"},{"input_actions":[],"name":"three","toggle_joystick":false,"type":"control_scheme"}]}'
	func test_reset_changes() -> void:
		# GIVEN
		InputMap.add_action(ACTION_NAME)

		var file := FileAccess.open(TEMP_FILE, FileAccess.WRITE)
		file.store_string(FILE_CONTENT)
		file.close()

		var storage_stub = load("res://addons/gato_input_remapper/service/storage_service.gd").new()
		storage_stub.settings_file = TEMP_FILE
		var input_remapper = sut.new(storage_stub)

		# simulate user changes
		var input_action = load("res://addons/gato_input_remapper/model/input_action_button.gd")\
			.new(ACTION_NAME, Helper.create_input_event(KEY_0))
		input_remapper.get_current_scheme().input_actions.append(input_action)

		# WHEN
		input_remapper.reset_changes()

		# THEN
		assert_eq(input_remapper.get_current_scheme().name, "one")
		assert_eq(input_remapper.get_current_scheme().input_actions.size(), 0)
		assert_true(InputMap.has_action(ACTION_NAME))
		var events := InputMap.action_get_events(ACTION_NAME)
		assert_eq(events.size(), 0, "The action has no input events")
		input_remapper.free()

		InputMap.erase_action(ACTION_NAME)
		DirAccess.remove_absolute(TEMP_FILE)
