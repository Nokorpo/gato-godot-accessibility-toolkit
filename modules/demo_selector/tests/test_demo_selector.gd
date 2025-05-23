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

	func test_demo_container_children_are_demo_previews():
		var scene: Node = add_child_autofree(demo_selector_scene.instantiate())
		var demo_container: Container = scene.find_child("DemoContainer")
		var demo_list_resource: DemoList = load("res://modules/demo_selector/demo_list.tres")
		assert_gt(demo_container.get_child_count(), 0, "the demo container is empty")
		
		for i: int in range(demo_container.get_child_count()):
			var preview = demo_container.get_child(i)
			assert_typeof(preview, typeof(DemoPreview), "a child of demo container is not of type DemoPreview")
			assert_eq(preview.data, demo_list_resource.demos[i], "The preview data %d matches with demo list data %d" % [i , i]) 

class TestDemoListResource extends GutTest:

	var demo_list_resource: DemoList = load("res://modules/demo_selector/demo_list.tres")

	func test_demo_list_resource_exist():
		assert_not_null(demo_list_resource, "Demo list resource doesn't exist")
		assert_not_null(demo_list_resource.get("demos"), "The demo list resource doesn't have the demos array")

	func test_demo_list_contains_demo_data():
		for item in demo_list_resource.demos:
			assert_typeof(item, typeof(DemoData), "The demo list doesn't contain DemoData values")
			assert_not_null(item.get("title"), "The demo has no title")
