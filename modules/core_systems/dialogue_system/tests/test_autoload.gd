## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends GutTest

class TestAutoload extends GutTest:

	var test_dialogue: DialogueContainer = load("res://modules/core_systems/dialogue_system/tests/test_dialogue.tres")

	func test_autoload_exists() -> void:
		var sut := $"/root/DialogueSystem"
		assert_not_null(sut)
		assert_has_method(sut, "load_dialogue")

	func test_load_message() -> void:
		var dialogue := DialogueSystem.load_dialogue(test_dialogue)

		assert_eq(dialogue.name, "One")
		assert_eq(dialogue.message, "First message")


	func test_advance_message() -> void:
		DialogueSystem.load_dialogue(test_dialogue)

		var dialogue := DialogueSystem.advance()

		assert_eq(dialogue.name, "Two")
		assert_eq(dialogue.message, "Second message")

	func test_run_out_of_messages() -> void:
		DialogueSystem.load_dialogue(test_dialogue)
		DialogueSystem._current_message_index = 2

		var dialogue := DialogueSystem.advance()

		assert_null(dialogue)
