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
