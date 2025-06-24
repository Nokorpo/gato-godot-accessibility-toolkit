extends CharacterBody3D

@export var speed: float = 2.0
@export_range(0, 1) var smoothing: float = 0.875

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	var input := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input.x, 0, input.y)).normalized()
	velocity = lerp(velocity, direction.normalized() * speed, 1-smoothing)
	
	move_and_slide()
