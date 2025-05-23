extends GutTest

class TestDemoSelectorScene extends GutTest:

	var demo_selector_scene: PackedScene = load("res://modules/demo_selector/demo_selector.tscn")

	func test_demo_selector_scene_exists():
		assert_not_null(demo_selector_scene, "the demo selector scene does not exist")

	func test_demo_container_has_children():
		var scene: Node = add_child_autofree(demo_selector_scene.instantiate())
		var demo_container: Container = scene.find_child("DemoContainer")

		assert_gte(demo_container.get_child_count(), 1, "demo container has no demos")
		assert_lte(demo_container.get_child_count(), 6, "demo container has more than 6 children")
