extends StateMachineState
class_name BoarFollowingAcornState


const EAT_RANGE: float = .6
const BOAR_FOLLOWING_ACORN_SPEED: float = .5

var boar: CharacterBody3D
var is_following: bool = false
var _target: Node3D = null
@export var mesh: BoarMesh

	
func _on_enter_state() -> void:
	mesh.play_animation(BoarMesh.Animations.WALK)
	
	boar = (node as CharacterBody3D)
	is_following = false

	_target = %AcornDetection.get_acorn_in_range()

	await detection_animation().finished
	is_following = true

func detection_animation() -> Tween:
	var tween := create_tween()
	tween.tween_property(boar, "scale", Vector3.ONE * 1.1, .4)
	tween.tween_property(boar, "scale", Vector3.ONE, .4)
	return tween

func look_at_acorn(delta: float):
	var diff := (_target.global_position - boar.global_position).normalized()
	boar.rotation.y = lerp_angle(boar.rotation.y, atan2(diff.x, diff.z), 2 * delta)

func short_angle_dist(from, to) -> float:
	var max_angle := TAU
	var difference := fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference

func trigonometry_angle_to_godot_angle(angle_radians):
	return -angle_radians + PI/2

func _on_exit_state() -> void:
	$"../EatingState".target = _target
	_target = null

func _physics_process(delta: float) -> void:
	if active:
		look_at_acorn(delta)
		if is_following:
			var target_diff: Vector3 = Plane.PLANE_XZ.project(_target.global_position - boar.global_position)
			if target_diff.length() <= EAT_RANGE:
				state_machine.change_state(BoarEatingState)
			else:
				boar.velocity = lerp(boar.velocity, target_diff.normalized() * BOAR_FOLLOWING_ACORN_SPEED, .5)
				boar.move_and_slide()
