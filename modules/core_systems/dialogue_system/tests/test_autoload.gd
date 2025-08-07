extends GutTest

class TestAutoload extends GutTest:

	func test_autoload_exists() -> void:
		var sut := $"/root/DialogueSystem"
		assert_not_null(sut)
		assert_has_method(sut, "load_dialog")

	func test_() -> void:
		pass
