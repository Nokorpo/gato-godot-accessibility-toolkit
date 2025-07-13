extends Node3D

@export var distance_on_land: float = 3
@export var height_at_peak: float = 2
@export var time_to_land: float = 1
@export var item_detection: Node3D

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("launch_item"):
		var item: Node3D = item_detection.pop_item()
		if item:
			var acorn: RigidBody3D = item
			acorn.global_transform = global_transform
			var horizontal_velocity = acorn.basis.z.normalized() * distance_on_land/time_to_land
			var vertical_velocity: float = 2*(height_at_peak-position.y)+0.25*9.8
			acorn.linear_velocity = Vector3(horizontal_velocity.x, vertical_velocity, horizontal_velocity.z)
