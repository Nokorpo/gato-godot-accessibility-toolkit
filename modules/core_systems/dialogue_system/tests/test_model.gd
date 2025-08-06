extends GutTest

class TestResources extends GutTest:

	var sut_message := load("res://modules/core_systems/dialogue_system/model/dialogue_message.gd")
	var sut_container := load("res://modules/core_systems/dialogue_system/model/dialogue_container.gd")

	func create_message() -> DialogueMessage:
		var message: DialogueMessage = sut_message.new()
		message.animation_name = "test"
		message.face = "test"
		message.name = "Test Character"
		message.message = "Test message [b]with bbcode![/b]"
		message.mesh = load("res://modules/core_systems/dialogue_system/tests/test_mesh.tscn")
		return message

	func test_message() -> void:
		var message := create_message()
		assert_not_null(message)
		assert_eq(message.name, "Test Character")
		assert_eq(message.message, "Test message [b]with bbcode![/b]")

	func test_message_container() -> void:
		var container: DialogueContainer = sut_container.new()
		assert_not_null(container)

		container.messages = [create_message()]
		assert_eq(container.messages.size(), 1)
		assert_eq(container.messages[0].message, "Test message [b]with bbcode![/b]")

	func test_get_all_meshes() -> void:
		var container: DialogueContainer = sut_container.new()
		container.messages = [create_message(), create_message(), create_message()]

		assert_eq(container.get_all_meshes().size(), 1, "multiple meshes show up when only one is used across multiple meshes")
