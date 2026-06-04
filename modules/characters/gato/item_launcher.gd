## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends Node3D

const GRAVITY := 9.8

@export var distance_on_land: float = 3
@export var height_at_peak: float = 2
@export var time_to_land: float = 1
@export var item_detection: Node3D

@onready var landing_spot_detector: Area3D = $ItemLandingSpotDetector

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("launch_item"):
		_launch_item()

func _launch_item() -> void:
	var item: Node3D = item_detection.pop_item()
	if item:
		var acorn: RigidBody3D = item
		acorn.global_transform = global_transform
		var landing_spot = _get_item_landing_spots()
		var horizontal_velocity: Vector3
		var vertical_velocity: float

		if landing_spot:
			# Since the flight time will change depending on how long the item needs to fall, we
			# calculate ascent and fall time separately. Then we use that total flight time to get
			# the horizontal velocity to reach the target at the correct time.
			var ascent_time := time_to_land / 2
			var fall_height: float = global_position.y + height_at_peak - landing_spot.y
			var descent_time: float = sqrt((2 * fall_height) / GRAVITY)
			var flight_time: float = ascent_time + descent_time
			vertical_velocity = (0.5 * GRAVITY * flight_time ** 2) / flight_time

			var distance: Vector3 = landing_spot - global_position
			horizontal_velocity = distance/flight_time
		else:
			horizontal_velocity = acorn.global_basis.z.normalized() * distance_on_land/time_to_land
			vertical_velocity = height_at_peak + (0.5 * GRAVITY * time_to_land ** 2) / time_to_land

		acorn.linear_velocity = Vector3(horizontal_velocity.x, vertical_velocity, horizontal_velocity.z)

## If there are any landing spots for a button in the landing spot detector area, it finds them. Returns a Vector3 or null.
func _get_item_landing_spots() -> Variant:
	if landing_spot_detector.has_overlapping_bodies():
		for body in landing_spot_detector.get_overlapping_bodies():
			if body.is_in_group("button"):
				return body.global_position
	return null
