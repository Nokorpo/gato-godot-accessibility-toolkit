## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
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

class TestInputActionButton extends GutTest:
	const ACTION_NAME := "act"
	var sut := load("res://addons/gato_input_remapper/model/input_action_button.gd")

	func test_creation_minimal() -> void:
		var input_event := Helper.create_input_event(KEY_SPACE)

		var input_config = sut.new(ACTION_NAME, input_event)

		assert_not_null(input_config)
		assert_has_method(input_config, "apply_config")

	func test_creation_with_category() -> void:
		var input_event := Helper.create_input_event(KEY_SPACE)

		var input_config = sut.new(ACTION_NAME, input_event, "important actions")

		assert_not_null(input_config)
		assert_has_method(input_config, "apply_config")
		assert_eq(input_config.category, "important actions")

	func test_apply() -> void:
		InputMap.add_action(ACTION_NAME)
		var input_event := Helper.create_input_event(KEY_SPACE)
		var input_config = sut.new(ACTION_NAME, input_event)

		input_config.apply_config()

		assert_true(InputMap.has_action(ACTION_NAME))
		var events := InputMap.action_get_events(ACTION_NAME)
		assert_gt(events.size(), 0, "The action has no input events")
		assert_eq(events[0].keycode, KEY_SPACE, "The action input is using a different key")

	func after_each() -> void:
		if InputMap.has_action(ACTION_NAME):
			InputMap.action_erase_events(ACTION_NAME)
			InputMap.erase_action(ACTION_NAME)

class TestJoystickInputAction2D extends GutTest:
	const ACTION_NAME := "act"
	var sut := load("res://addons/gato_input_remapper/model/joystick_input_action_2d.gd")

	func test_apply() -> void:
		Helper.initialize_directional_input(ACTION_NAME)
		var input_config = sut.new(ACTION_NAME, true, true)

		input_config.apply_config()

		for direction in ["up", "down", "left", "right"]:
			var action_name := "%s_%s" % [ACTION_NAME, direction.to_lower()]
			assert_true(InputMap.has_action(action_name))
			var events := InputMap.action_get_events(action_name)
			assert_gt(events.size(), 0, "The action %s has no input events" % action_name)
			assert_typeof(events[0], typeof(InputEventJoypadMotion), "The action %s input is not using a joystick" % action_name)

	func after_each() -> void:
		for direction in sut.Direction.keys():
			var action_name := "%s_%s" % [ACTION_NAME, direction.to_lower()]
			if InputMap.has_action(action_name):
				InputMap.action_erase_events(action_name)
				InputMap.erase_action(action_name)

class TestKeysInputAction2D extends GutTest:
	const ACTION_NAME := "act"
	var sut := load("res://addons/gato_input_remapper/model/keys_input_action_2d.gd")

	func test_apply() -> void:
		Helper.initialize_directional_input(ACTION_NAME)
		var input_up := Helper.create_input_event(KEY_W)
		var input_down := Helper.create_input_event(KEY_S)
		var input_left := Helper.create_input_event(KEY_A)
		var input_right := Helper.create_input_event(KEY_D)

		var input_config = sut.new(ACTION_NAME, input_up, input_down, input_left, input_right)

		input_config.apply_config()

		for direction in ["up", "down", "left", "right"]:
			var action_name := "%s_%s" % [ACTION_NAME, direction]
			assert_true(InputMap.has_action(action_name))
			var events := InputMap.action_get_events(action_name)
			assert_gt(events.size(), 0, "The action %s has no input events" % action_name)
			assert_typeof(events[0], typeof(InputEventJoypadMotion), "The action %s input is not using a joystick" % action_name)

	func after_each() -> void:
		for direction in sut.Direction.keys():
			var action_name := "%s_%s" % [ACTION_NAME, direction.to_lower()]
			if InputMap.has_action(action_name):
				InputMap.action_erase_events(action_name)
				InputMap.erase_action(action_name)
