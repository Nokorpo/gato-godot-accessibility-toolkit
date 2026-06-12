## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends StateMachineState
class_name BoarFollowingAcornState


const EAT_RANGE: float = .7
const BOAR_FOLLOWING_ACORN_SPEED: float = .5

@export var mesh: BoarMesh
@export var has_ground_ahead_raycasts: Array[RayCast3D]

var boar: CharacterBody3D
var is_following: bool = false
var _target: Node3D = null

func _ready() -> void:
	for raycast: RayCast3D in has_ground_ahead_raycasts:
		raycast.process_mode = Node.PROCESS_MODE_DISABLED

func _on_enter_state() -> void:
	mesh.play_animation(BoarMesh.Animations.WALK)

	boar = (node as CharacterBody3D)
	is_following = false

	_target = %AcornDetection.get_acorn_in_range()

	for raycast: RayCast3D in has_ground_ahead_raycasts:
		raycast.process_mode = Node.PROCESS_MODE_INHERIT

	await detection_animation().finished
	is_following = true

func detection_animation() -> Tween:
	var tween := create_tween()
	tween.tween_property(boar, "scale", boar.scale * 1.1, .4)
	tween.tween_property(boar, "scale", boar.scale, .4)
	return tween

func look_at_acorn(delta: float):
	var diff := (_target.global_position - boar.global_position).normalized()
	boar.global_rotation.y = lerp_angle(boar.global_rotation.y, atan2(diff.x, diff.z), 2 * delta)

func short_angle_dist(from, to) -> float:
	var max_angle := TAU
	var difference := fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference

func _on_exit_state() -> void:
	$"../EatingState".target = _target
	_target = null
	for raycast: RayCast3D in has_ground_ahead_raycasts:
		raycast.process_mode = Node.PROCESS_MODE_DISABLED

func _has_ground_ahead() -> bool:
	var has_ground: int = 0
	for raycast: RayCast3D in has_ground_ahead_raycasts:
		if raycast.is_colliding():
			has_ground += 1
	return has_ground > 0

func _physics_process(delta: float) -> void:
	if active:
		if not is_instance_valid(_target):
			state_machine.change_state(BoarIdleState)
			return
		look_at_acorn(delta)
		if is_following:
			if not _has_ground_ahead():
				state_machine.change_state(BoarIdleState)
				return
			var target_diff: Vector3 = _target.global_position - boar.global_position
			if abs(target_diff.y) >= 1.:
				state_machine.change_state(BoarIdleState)
				return
			if target_diff.length() <= EAT_RANGE * boar.scale.y:
				state_machine.change_state(BoarEatingState)
			else:
				boar.velocity = lerp(boar.velocity, target_diff.normalized() * BOAR_FOLLOWING_ACORN_SPEED, .5)
				boar.move_and_slide()
