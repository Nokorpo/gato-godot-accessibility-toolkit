extends GutTest

class TestItemDetection extends GutTest:

	## sut is short for "system under test"
	var sut: PackedScene = load("res://modules/characters/gato/item_detection_area.tscn")

	var acorn_scene: PackedScene = load("res://modules/acorn/acorn.tscn")

	func test_item_detection_and_item_container_exists():
		#GIVEN
		var item_detection: Area3D = add_child_autofree(sut.instantiate())

		#WHEN
		var item_container: Node3D = item_detection.find_child("ItemContainer")

		#THEN
		assert_not_null(item_detection, "Item detection area does not exists")
		assert_not_null(item_container, "Item container does not exists")

	func test_item_detection_area_detects_acorn():
		#GIVEN
		var item_detection: Area3D = add_child_autofree(sut.instantiate())
		watch_signals(item_detection)
		var _acorn: Node3D = add_child_autofree(acorn_scene.instantiate())

		#WHEN
		await wait_for_signal(item_detection.body_entered, .5, "waiting for the acorn to be detected")

		#THEN
		assert_signal_emitted(item_detection, "body_entered", "the acorn was not detected by the item detection area")

	func test_item_container_stores_acorn():
		#GIVEN
		DebugMenu.animation_speed = 0
		var item_detection: Area3D = add_child_autofree(sut.instantiate())
		var item_container: Node3D = item_detection.find_child("ItemContainer")
		var acorn: Node3D = add_child_autofree(acorn_scene.instantiate())

		#WHEN
		item_container._on_item_detection_area_body_entered(acorn)
		await wait_for_signal(item_container.item_collected, 2, "item detection wasn't signaled")

		#THEN
		assert_eq(item_container.items.size(), 1, "The acorn is not stored in the item list")
		assert_eq(item_container.items[0], acorn, "The acorn is not stored in the item list")

	func test_item_container_doesnt_store_same_item_twice():
		#GIVEN
		DebugMenu.animation_speed = 0
		var item_detection: Area3D = add_child_autofree(sut.instantiate())
		var item_container: Node3D = item_detection.find_child("ItemContainer")
		var acorn: Node3D = add_child_autofree(acorn_scene.instantiate())

		#WHEN
		item_container._on_item_detection_area_body_entered(acorn)
		item_container._on_item_detection_area_body_entered(acorn)
		await wait_for_signal(item_container.item_collected, 2, "item detection wasn't signaled")

		#THEN
		assert_eq(item_container.items.size(), 1, "The acorn is not stored in the item list")
		assert_eq(item_container.items[0], acorn, "The acorn is not stored in the item list")

	func test_stored_acorn_follows_item_container():
		#GIVEN
		DebugMenu.animation_speed = 0
		var item_detection: Area3D = add_child_autofree(sut.instantiate())
		var item_container: Node3D = item_detection.find_child("ItemContainer")
		var acorn: Node3D = add_child_autofree(acorn_scene.instantiate())
		item_container._on_item_detection_area_body_entered(acorn)

		#WHEN
		item_container.global_position = Vector3(10,0,0)
		await wait_for_signal(item_container.item_collected, 2, "item detection wasn't signaled")

		#THEN
		assert_almost_eq(acorn.global_position, Vector3(10,0,0), Vector3.ONE, "the acorn didn't follow the item container when it moved")
