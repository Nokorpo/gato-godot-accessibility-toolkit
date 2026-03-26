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
