extends GutTest

class TestAcornLaunchAndButton extends GutTest:

	## sut is short for "system under test"
	var sut: PackedScene = load("res://modules/characters/gato/tests/test_item_throw.tscn")

	var acorn_scene: PackedScene = load("res://modules/level_objects/acorn/acorn.tscn")

	func test_button_is_detected():
		#GIVEN
		var test_scene: Node3D = add_child_autofree(sut.instantiate())
		var gato: Gato = test_scene.find_child("Gato")
		var item_launcher = gato.find_child("ItemLauncher", true, false)
		await wait_frames(2)

		#WHEN
		var landing_spot_position: Vector3 = item_launcher._get_item_landing_spots()

		#THEN
		assert_not_null(landing_spot_position, "The button was not detected")
		assert_eq(landing_spot_position, Vector3(0, 0, 3) , "The button was not detected")

	func test_button_is_detected_15_deg():
		#GIVEN
		var test_scene: Node3D = add_child_autofree(sut.instantiate())
		var gato: Gato = test_scene.find_child("Gato")
		gato.rotate_y(deg_to_rad(15))
		var item_launcher = gato.find_child("ItemLauncher", true, false)
		await wait_frames(2)

		#WHEN
		var landing_spot_position: Vector3 = item_launcher._get_item_landing_spots()

		#THEN
		assert_not_null(landing_spot_position, "The button was not detected")
		assert_eq(landing_spot_position, Vector3(0, 0, 3) , "The button was not detected")

	func test_button_is_detected_30_deg():
		#GIVEN
		var test_scene: Node3D = add_child_autofree(sut.instantiate())
		var gato: Gato = test_scene.find_child("Gato")
		gato.rotate_y(deg_to_rad(30))
		var item_launcher = gato.find_child("ItemLauncher", true, false)
		await wait_frames(2)

		#WHEN
		var landing_spot_position: Vector3 = item_launcher._get_item_landing_spots()

		#THEN
		assert_not_null(landing_spot_position, "The button was not detected")
		assert_eq(landing_spot_position, Vector3(0, 0, 3) , "The button was not detected")

	func test_button_is_detected_45_deg():
		#GIVEN
		var test_scene: Node3D = add_child_autofree(sut.instantiate())
		var gato: Gato = test_scene.find_child("Gato")
		gato.rotate_y(deg_to_rad(45))
		var item_launcher = gato.find_child("ItemLauncher", true, false)
		await wait_frames(2)

		#WHEN
		var landing_spot_position: Variant = item_launcher._get_item_landing_spots()

		#THEN
		assert_null(landing_spot_position, "The button was detected when it shouldn't have been")
