extends Node3D

@export_group("Properties")
@export var target: Node
@export var camera_speed: float = 10

@export_group("Zoom")
@export var zoom_minimum = 16
@export var zoom_maximum = 4
@export var zoom_speed = 10

@export_group("Rotation (joystick)")
@export var joystick_rotation_sensitivity: float = 2
var camera_rotation: Vector3
var zoom: float = 10
var initial_rotation: Vector3

@export_group("Rotation (mouse)")
@export var mouse_rotation_sensitivity: float = .05
var mouse_delta: Vector2 = Vector2.ZERO

@onready var camera = $Node3D/Camera
@onready var horizontal_axis: Node3D = self
@onready var vertical_axis: Node3D = $Node3D
@onready var camera_collision_raycast = $Node3D/RayCast3D

var collision_zoom: Vector3 = Vector3(0,1,0)

func _ready():
	initial_rotation = rotation

func _process(delta: float) -> void:
	_handle_rotation_from_mouse(delta)
	_handle_rotation_from_buttons(delta)
	handle_camera_collision()

func _physics_process(delta: float) -> void:
	if target != null:
		self.position = self.position.lerp(target.position, delta * 4)
	camera.position = camera.position.lerp(Vector3(0, 0, zoom), 8 * delta)

func _handle_rotation_from_buttons(delta):
	var input := Vector2.ZERO

	input.x = Input.get_axis("camera_right", "camera_left")
	input.y = Input.get_axis("camera_up", "camera_down")

	mouse_delta = input
	if not input.is_equal_approx(Vector2.ZERO):
		rotate_in_direction(input * delta * joystick_rotation_sensitivity)

func _input(event):
	if event is InputEventMouseMotion:
		mouse_delta = event.relative

	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_RIGHT:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if event.pressed else Input.MOUSE_MODE_VISIBLE)

func _handle_rotation_from_mouse(delta):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_in_direction(-mouse_delta * delta * mouse_rotation_sensitivity)

func rotate_in_direction(movement_delta: Vector2) -> void:
	horizontal_axis.rotate_y(movement_delta.x)
	vertical_axis.rotate_x(movement_delta.y)
	if vertical_axis.rotation.x >= 2 * PI/5:
		vertical_axis.rotation.x = 2 * PI/5
	elif vertical_axis.rotation.x <= -2 * PI/5:
		vertical_axis.rotation.x = -2 * PI/5

func handle_camera_collision():
	if camera_collision_raycast.is_colliding():
		var _camera_initial_transform = camera.global_position
		var collider = camera_collision_raycast.get_collider()
		if collider.is_in_group("CameraCollider"):
			camera.global_transform.origin = camera_collision_raycast.get_collision_point() + collision_zoom

func reset_rotation():
	position = Vector3.ZERO
	rotation = initial_rotation
