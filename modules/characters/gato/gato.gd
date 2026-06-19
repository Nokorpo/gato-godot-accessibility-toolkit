## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
class_name Gato
extends CharacterBody3D

signal fall_from_height
signal item_collected(item: Node3D)
signal fall_into_water

@export var speed: float = 2.0
@export var jump_force: float = 3
@export_range(0, 1) var smoothing: float = 0.75
@export var rotation_speed: float = 10.0
@export var height_to_respawn: float = -3.0

@export_category("Sounds")
@export var splash_sfx: AudioStreamPlayer
@export var light_landing_sfx: AudioStreamPlayer
@export var hard_landing_sfx: AudioStreamPlayer

@onready var pivot: Node3D = $RotationPivot
@onready var camera: Camera3D = get_viewport().get_camera_3d()
@onready var mesh: GatoMesh = $RotationPivot/Mesh
@onready var item_detection: Node3D = $RotationPivot/ItemDetectionArea
@onready var items: Array = item_detection.items

var previous_y_velocity: float = 0.0
## When the character is respawning, we wait a short amount of time before moving it to the respawn point.
## In order to stop the character and camera, we skip calculating movement with this flag.
var _is_respawning: bool = false

func _ready() -> void:
	item_detection.item_collected.connect(func(it): item_collected.emit(it))
	DialogueSystem.dialogue_started.connect(set.bind("process_mode", Node.PROCESS_MODE_DISABLED))
	DialogueSystem.dialogue_finished.connect(set.bind("process_mode", Node.PROCESS_MODE_INHERIT))

func _physics_process(delta: float) -> void:
	if _is_respawning:
		return

	if not is_on_floor():
		previous_y_velocity = velocity.y
		velocity += get_gravity() * delta
		mesh.is_grounded = false
		if position.y < height_to_respawn:
			respawn()
	else:
		mesh.is_grounded = true
		if previous_y_velocity <= -5.0:
			fall_from_height.emit()

	var input := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction: Vector2
	if camera and camera.has_method("get_horizontal_rotation"):
		direction = input.rotated(-camera.get_horizontal_rotation()).normalized()
	else:
		direction = Vector2(input.x, input.y)
	velocity.x = lerp(velocity.x, direction.normalized().x * speed, 1-smoothing)
	velocity.z = lerp(velocity.z, direction.normalized().y * speed, 1-smoothing)

	if direction:
		var target_angle := Vector3.BACK.signed_angle_to(Vector3(direction.x, 0, direction.y), Vector3.UP)
		pivot.rotation.y = lerp_angle(pivot.rotation.y, target_angle, rotation_speed * delta)
		mesh.is_moving = true
	else:
		mesh.is_moving = false

	move_and_slide()
	_collide_with_objects_that_react()

func _collide_with_objects_that_react() -> void:
	for i in range(get_slide_collision_count()):
		var collision := get_slide_collision(i)
		var object: Node = collision.get_collider().owner
		if object != null and object.has_method("react_to_player_collision"):
			object.react_to_player_collision()

func jump() -> void:
	velocity.y = jump_force

func respawn() -> void:
	splash_sfx.play()
	_is_respawning = true
	await splash_sfx.finished
	_is_respawning = false

	fall_into_water.emit()
	global_position = Vector3.ZERO
