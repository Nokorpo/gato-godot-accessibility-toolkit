extends Node3D

@export_group("Properties")
@export var target: Node

@export_group("Zoom")
@export var zoom_minimum = 16
@export var zoom_maximum = 4
@export var zoom_speed = 10

@export_group("Rotation (buttons)")
@export var rotation_speed: float = 120
var camera_rotation: Vector3
var zoom: float = 10

@export_group("Rotation (mouse)")
@export var camera_speed: float = 10
@export var sensitivity: float = .15
var target_basis: Basis = Basis.IDENTITY
var second_basis: Basis = Basis.IDENTITY
const _threshold: float = 0.00001
var mouse_delta: Vector2 = Vector2.ZERO

@onready var camera = $Camera
var using_mouse: bool = true

func _ready():
	init_mouse_rotation_variables()

func init_mouse_rotation_variables() -> void:
	camera_rotation = rotation_degrees
	target_basis = transform.basis
	var original_rotation: Vector3 = transform.basis.get_rotation_quaternion().get_euler()
	second_basis = Basis(Quaternion.from_euler(Vector3(0, original_rotation.y, 0)))

func _process(delta: float) -> void:
	# TODO switch between one or the other depending on whether the player uses controller or mouse
	if using_mouse:
		_handle_rotation_from_mouse(delta)
	else:
		_handle_rotation_from_buttons(delta)

func _physics_process(delta: float) -> void:
	self.position = self.position.lerp(target.position, delta * 4)
	camera.position = camera.position.lerp(Vector3(0, 0, zoom), 8 * delta)

func _handle_rotation_from_buttons(delta):
	var input := Vector3.ZERO

	# TODO adaptar esto a usar un joystick o el ratón con el inputremapper
	input.y = Input.get_axis("camera_left", "camera_right")
	input.x = Input.get_axis("camera_up", "camera_down")

	camera_rotation += input.limit_length(1.0) * rotation_speed * delta
	camera_rotation.x = clamp(camera_rotation.x, -80, -10)

	zoom += Input.get_axis("zoom_in", "zoom_out") * zoom_speed * delta
	zoom = clamp(zoom, zoom_maximum, zoom_minimum)

func _input(event):
	if event is InputEventMouseMotion:
		mouse_delta = event.relative

	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_RIGHT:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if event.pressed else Input.MOUSE_MODE_VISIBLE)

## Original code from: https://forum.godotengine.org/t/fps-camera-quaternions-movement-slows-down-when-looking-up-and-down/93458/4
func _handle_rotation_from_mouse(delta):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mouse_delta = -mouse_delta * delta * sensitivity
		var delta_y_max = (-target_basis.z).angle_to(Vector3.UP * sign(mouse_delta.y))
		mouse_delta.y = clamp(abs(mouse_delta.y), 0.0, delta_y_max - _threshold) * sign(mouse_delta.y)
		var horz_quat = Quaternion(Vector3.UP * target_basis, mouse_delta.x)
		var horz_quat_no_pitch = Quaternion(Vector3.UP * second_basis, mouse_delta.x)
		var vert_quat = Quaternion(Vector3.RIGHT, mouse_delta.y)
		target_basis *= Basis(horz_quat * vert_quat)
		second_basis *= Basis(horz_quat_no_pitch)
		target_basis = target_basis.orthonormalized()
	transform.basis = transform.basis.slerp(target_basis, delta * camera_speed)
