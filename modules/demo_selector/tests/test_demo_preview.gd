extends GutTest

class TestDemoPreviewScene extends GutTest:

	var demo_preview_scene: PackedScene = load("res://modules/demo_selector/demo_preview.tscn")

	func test_demo_preview_scene_exists():
		assert_not_null(demo_preview_scene, "the demo selector scene does not exist")
		
	func test_demo_preview_has_demo_data():
		var preview: DemoPreview = add_child_autofree(demo_preview_scene.instantiate())
		assert_not_null(preview.data, "The preview doesn't have demo data")

	func test_demo_preview_image_matches_with_demo_data_image():
		var preview: DemoPreview = add_child_autofree(demo_preview_scene.instantiate())
		var image: TextureRect = preview.find_child("TextureRect")
		assert_not_null(image.texture, "the preview has no image")
		assert_not_null(preview.data, "The preview doesn't have demo data")
		if preview.data:
			assert_eq(image.texture, preview.data.image, "The preview image doesnt match with demo data image") 
