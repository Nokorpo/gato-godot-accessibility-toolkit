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

		assert_gt(ui.find_child("CharacterContainer").size.x, 0.0,
			"the character viewport is not visible")
		assert_gt(ui.find_child("CharacterContainer").size.y, 0.0,
			"the character viewport is not visible")

	func test_message_change_on_click() -> void:
		var ui: Control = add_child_autofree(sut.instantiate())
		DialogueSystem.load_dialogue(test_dialog)

		var click := InputEventMouseButton.new()
		click.button_index = MOUSE_BUTTON_LEFT
		click.pressed = true
		ui._input(click)

		assert_eq(ui.name_label.text, "Two", "the text didn't change")
		assert_eq(ui.message_label.text, "Second message", "the text didn't change")

class TestDialogueAvatarUI extends GutTest:

	var sut: PackedScene = load("res://modules/core_systems/dialogue_system/view/character_container_ui.tscn")
	var example_avatar: PackedScene = load("res://modules/characters/gato/mesh/gato_mesh.tscn")

	func _get_example_message() -> DialogueMessage:
		var dialogue := DialogueMessage.new()
		dialogue.mesh = example_avatar
		dialogue.animation_name = "talk_happy"
		dialogue.face = ""
		return dialogue

	func test_mesh_is_instantiatied() -> void:
		var character_ui: Control = add_child_autofree(sut.instantiate())
		character_ui.set_avatar(example_avatar, "talk_neutral")

		await wait_frames(8, "wait for AnimationTree state machine to change state")

		assert_eq(character_ui._cached_characters.keys().size(), 1)
		assert_true(character_ui._cached_characters.has(example_avatar))
		assert_typeof(character_ui._cached_characters[example_avatar], typeof(Node3D))

	func test_mesh_has_right_animation() -> void:
		var character_ui: Control = add_child_autofree(sut.instantiate())
		character_ui.set_avatar(example_avatar, "talk_neutral")

		await wait_frames(8, "wait for AnimationTree state machine to change state")

		var animation_tree: AnimationTree = character_ui._cached_characters[example_avatar].animation_tree
		assert_eq(animation_tree["parameters/playback"].get_current_node(), "talk_neutral")
