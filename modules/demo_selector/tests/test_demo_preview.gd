extends GutTest

class TestDemoPreviewScene extends GutTest:

	var demo_preview_scene: PackedScene = load("res://modules/demo_selector/demo_preview.tscn")

	func test_demo_preview_scene_exists():
		assert_not_null(demo_preview_scene, "the demo selector scene does not exist")

	func test_demo_preview_contains_preview_image():
		var preview: Control = add_child_autofree(demo_preview_scene.instantiate())
		var image: TextureRect = preview.find_child("TextureRect")
		assert_not_null(image.texture, "the preview has no image")
