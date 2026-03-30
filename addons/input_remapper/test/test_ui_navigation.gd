extends GutTest

class TestRowNavigationContainer extends GutTest:
	var sut := load("res://addons/input_remapper/ui/row_navigation_container.tscn")

	func test_autoload_initializes_storage_service() -> void:
		var row = add_child_autofree(sut.instantiate())

		var highlight_panel: Panel = row.find_child("Panel")
		assert_not_null(highlight_panel)
		assert_false(highlight_panel.visible)

	func test_mouse_entered() -> void:
		var row = add_child_autofree(sut.instantiate())
		var highlight_panel: Panel = row.find_child("Panel")

		row._on_mouse_entered()

		assert_true(highlight_panel.visible)
		assert_eq(get_viewport().gui_get_focus_owner(), row)

	func test_mouse_exited() -> void:
		var row = add_child_autofree(sut.instantiate())
		row.grab_focus()

		row._on_mouse_exited()

		var highlight_panel: Panel = row.find_child("Panel")
		assert_false(highlight_panel.visible)
		assert_ne(get_viewport().gui_get_focus_owner(), row)

	func test_click() -> void:
		var row = add_child_autofree(sut.instantiate())
		watch_signals(row)
		row.grab_focus()

		var event := InputEventMouseButton.new()
		event.button_index = MOUSE_BUTTON_LEFT
		event.pressed = true
		row._input(event)

		assert_signal_emitted(row.pressed)

	func test_confirm() -> void:
		var row = add_child_autofree(sut.instantiate())
		watch_signals(row)
		row.grab_focus()

		var event := InputEventAction.new()
		event.action = "ui_accept"
		event.pressed = true
		row._input(event)

		assert_signal_emitted(row.pressed)

	func test_option_select_right() -> void:
		var row = add_child_autofree(sut.instantiate())
		watch_signals(row)
		row.grab_focus()

		var action_right := InputEventAction.new()
		action_right.action = "ui_right"
		action_right.pressed = true
		row._input(action_right)

		assert_signal_emitted(row, "input")
		assert_eq(get_signal_parameters(row, "input"), [action_right])

	func test_option_select_left() -> void:
		var row = add_child_autofree(sut.instantiate())
		watch_signals(row)
		row.grab_focus()

		var action_left := InputEventAction.new()
		action_left.action = "ui_left"
		action_left.pressed = true
		row._input(action_left)

		assert_signal_emitted(row, "input")
		assert_eq(get_signal_parameters(row, "input"), [action_left])

class TestIntegrationJoystickSelection extends GutTest:
	var sut := load("res://addons/input_remapper/ui/input_remapper_ui.tscn")

	func _find_first_row(ui_element: Control) -> RowNavigationContainer:
		var row_index: int = ui_element.get_children().find_custom(
			func(it): return it is RowNavigationContainer
		)
		if row_index == -1:
			push_error("Tried to find an element of type RowNavigationContainer in children from %s, but none found" % ui_element.name)
			return null
		return ui_element.get_child(row_index)

	func _create_joystick_right_event() -> InputEventJoypadMotion:
		var event := InputEventJoypadMotion.new()
		event.axis = 0
		event.axis_value = 1.0
		return event

	func test_joystick_right_selects_next_control_scheme() -> void:
		var ui: Control = add_child_autofree(sut.instantiate())
		var control_scheme_selector: Control = ui.find_child("ControlSchemeSelector", true, false)
		var row := _find_first_row(control_scheme_selector)
		row.grab_focus()
		var initial_text: String = control_scheme_selector.current_scheme_label.text

		row._input(_create_joystick_right_event())

		assert_ne(control_scheme_selector.current_scheme_label.text, initial_text)

	func test_repeated_joystick_motion_does_not_change_selection_control_scheme() -> void:
		var ui: Control = add_child_autofree(sut.instantiate())
		var control_scheme_selector: Control = ui.find_child("ControlSchemeSelector", true, false)
		var row := _find_first_row(control_scheme_selector)
		row.grab_focus()
		var initial_text: String = control_scheme_selector.current_scheme_label.text

		row._input(_create_joystick_right_event())
		var second_text: String = control_scheme_selector.current_scheme_label.text

		row._input(_create_joystick_right_event())

		assert_ne(control_scheme_selector.current_scheme_label.text, initial_text)
		assert_eq(control_scheme_selector.current_scheme_label.text, second_text)

	func test_joystick_right_selects_next_keyboard_and_joystick() -> void:
		var ui: Control = add_child_autofree(sut.instantiate())
		var joystick_toggle: Control = ui.find_child("JoystickToggle", true, false)
		var row := joystick_toggle.get_parent()
		row.grab_focus()
		var label: Label = joystick_toggle.find_child("Label")
		var initial_text: String = label.text

		row._input(_create_joystick_right_event())

		assert_ne(label.text, initial_text)
		InputRemapper.reset_changes()

	func test_repeated_joystick_motion_does_not_change_selection_keyboard_and_joystick() -> void:
		var ui: Control = add_child_autofree(sut.instantiate())
		var joystick_toggle: Control = ui.find_child("JoystickToggle", true, false)
		var row := joystick_toggle.get_parent()
		row.grab_focus()
		var label: Label = joystick_toggle.find_child("Label")
		var initial_text: String = label.text

		row._input(_create_joystick_right_event())
		var second_text: String = label.text

		row._input(_create_joystick_right_event())

		assert_eq(label.text, second_text)
		assert_ne(label.text, initial_text)
		InputRemapper.reset_changes()

	func test_joystick_right_selects_next_left_right_joystick() -> void:
		var ui: Control = add_child_autofree(sut.instantiate())
		var joystick_selector: Control = ui.find_child("JoystickSelector", true, false)
		var row := joystick_selector.get_parent()
		row.grab_focus()
		var label: Label = joystick_selector.find_child("Label")
		var initial_text: String = label.text

		row._input(_create_joystick_right_event())

		assert_ne(label.text, initial_text)
		InputRemapper.reset_changes()

	func test_repeated_joystick_motion_does_not_change_selection_left_right_joystick() -> void:
		var ui: Control = add_child_autofree(sut.instantiate())
		var joystick_selector: Control = ui.find_child("JoystickSelector", true, false)
		var row := joystick_selector.get_parent()
		row.grab_focus()
		var label: Label = joystick_selector.find_child("Label")
		var initial_text: String = label.text

		row._input(_create_joystick_right_event())
		var second_text: String = label.text

		row._input(_create_joystick_right_event())

		assert_eq(label.text, second_text)
		assert_ne(label.text, initial_text)
		InputRemapper.reset_changes()
