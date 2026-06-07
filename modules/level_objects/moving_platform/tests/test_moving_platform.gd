## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends GutTest

class TestMovingPlatforms extends GutTest:

	var test_scene: PackedScene = load("res://modules/level_objects/moving_platform/tests/test_moving_platform.tscn")

	func test_method_exists():
		var scene: Node = add_child_autofree(test_scene.instantiate())
		var platform: Node3D = scene.find_child("MovingPlatform")

		assert_has_method(platform, "travel_to_destination")

	func test_parent_is_found():
		var scene: Node = add_child_autofree(test_scene.instantiate())
		var platform: Node3D = scene.find_child("MovingPlatform")
		var acorn_platform: Node3D = scene.find_child("MovingAcornPlatform")

		assert_eq(platform.node_to_move, acorn_platform)

	func test_destination_is_found():
		var scene: Node = add_child_autofree(test_scene.instantiate())
		var platform: Node3D = scene.find_child("MovingPlatform")

		assert_almost_eq(platform.destination, Vector3(2.0, 2.0, 0.0), Vector3(.1, .1, .1))

	func test_move_to_destination():
		var scene: Node = add_child_autofree(test_scene.instantiate())
		var platform: Node3D = scene.find_child("MovingPlatform")
		watch_signals(platform)
		platform.travel_time = 0.0

		platform.travel_to_destination()
		await wait_for_signal(platform.target_reached, 2, "wait for platform to get into place")

		assert_almost_eq(platform.global_position, platform.destination, Vector3(.1, .1, .1))
		assert_signal_emitted(platform, "target_reached")

	func test_move_to_origin():
		var scene: Node = add_child_autofree(test_scene.instantiate())
		var platform: Node3D = scene.find_child("MovingPlatform")
		platform.travel_time = 0.0
		platform.travel_to_destination()
		watch_signals(platform)

		platform.travel_to_origin()
		await wait_for_signal(platform.target_reached, 2, "wait for platform to get into place")

		assert_almost_eq(platform.global_position, Vector3.ZERO, Vector3(.1, .1, .1))
		assert_signal_emitted(platform, "target_reached")
