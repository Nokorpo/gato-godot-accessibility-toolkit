extends Node3D

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
		if landing_spot:
			var distance: Vector3 = landing_spot - global_position
			horizontal_velocity = distance.normalized() * distance.length()/time_to_land
		else:
			horizontal_velocity = acorn.global_basis.z.normalized() * distance_on_land/time_to_land
		var vertical_velocity: float = 2*(height_at_peak-position.y)+0.25*9.8
		acorn.linear_velocity = Vector3(horizontal_velocity.x, vertical_velocity, horizontal_velocity.z)

## If there are any landing spots for a button in the landing spot detector area, it finds them. Returns a Vector3 or null.
func _get_item_landing_spots() -> Variant:
	if landing_spot_detector.has_overlapping_bodies():
		for body in landing_spot_detector.get_overlapping_bodies():
			if body.is_in_group("button"):
				return body.global_position
	return null
