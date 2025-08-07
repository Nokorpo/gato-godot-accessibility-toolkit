extends GutTest

class TestDialogueUI extends GutTest:

	var sut: PackedScene = load("res://modules/core_systems/dialogue_system/view/dialogue_ui.tscn")
	var test_dialog: DialogueContainer = load("res://modules/core_systems/dialogue_system/tests/test_dialogue.tres")

	func test_name_and_message() -> void:
		var ui: Control = add_child_autofree(sut.instantiate())
		var message: DialogueMessage = test_dialog.messages[0]

		ui.set_message(message)

		assert_eq(ui.find_child("NameLabel").text, message.name)
		assert_eq(ui.find_child("MessageLabel").text, message.message)

	func test_viewport_size() -> void:
		var ui: Control = add_child_autofree(sut.instantiate())

		var window_size := get_window().size

		assert_almost_eq(ui.find_child("SubViewport").size, Vector2i(window_size.x/2, window_size.y), Vector2i(64, 4),
			"the character viewport didn't adapt to the window size")

	func test_character_mesh_change() -> void:
		var ui: Control = add_child_autofree(sut.instantiate())
		var character: Node3D = ui.find_child("CharacterMesh")
