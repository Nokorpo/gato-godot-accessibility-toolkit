extends CharacterBody3D

@export var speed: float = 2.0
@export var jump_force: float = 3
@export_range(0, 1) var smoothing: float = 0.875
@export var rotation_speed: float = 10.0

@onready var pivot: Node3D = $RotationPivot
@onready var camera: Camera3D = get_viewport().get_camera_3d()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	
	var input := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (camera.global_transform.basis * Vector3(input.x, 0, input.y)).normalized()
	velocity.x = lerp(velocity.x, direction.normalized().x * speed, 1-smoothing)
	velocity.z = lerp(velocity.z, direction.normalized().z * speed, 1-smoothing)

	if direction:
		var target_angle := Vector3.BACK.signed_angle_to(direction, Vector3.UP)
		pivot.rotation.y = lerp_angle(pivot.rotation.y, target_angle, rotation_speed * delta)

	move_and_slide()

func jump() -> void:
	velocity.y = jump_force
