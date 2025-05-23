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
		var demo_list_resource: Resource = load("res://modules/demo_selector/demo_list.tres")
		assert_true(demo_container.get_child_count() == demo_list_resource.demos.size(),
			"The child count doesn't match with de quantity of demos of the demo list resource")

class TestDemoListResource extends GutTest:

	func test_demo_list_resource_exist():
		var demo_list_resource: Resource = load("res://modules/demo_selector/demo_list.tres")
		assert_not_null(demo_list_resource, "Demo list resource doesn't exist")
		assert_not_null(demo_list_resource.get("demos"), "The demo list resource doesn't have the demos array")
