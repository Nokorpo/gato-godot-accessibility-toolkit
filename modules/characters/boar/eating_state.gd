## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends StateMachineState
class_name BoarEatingState

@onready var particles: CPUParticles3D = $"../../CPUParticles3D"
@onready var heart_particles: GPUParticles3D = $"../../HeartParticles"
var target = null
var boar: CharacterBody3D
@export var mesh: BoarMesh
@export var eating_time: float = 1.5
var is_grown: bool = false

func _start(_state_machine: StateMachine, _node: Node) -> void:
	super(_state_machine, _node)
	boar = _node as CharacterBody3D

func _on_enter_state() -> void:
	mesh.play_animation(BoarMesh.Animations.EAT)
	particles.emitting = true
	await get_tree().create_timer(eating_time).timeout
	if is_instance_valid(target):
		await target.animate_acorn_disappearance()
	state_machine.call_deferred("change_state", BoarIdleState)

#TODO move to acorn code
func animate_acorn_disappearance():
	# We use this vector instead of Vector3.ZERO because setting a scale of
	# zero is not supported by Jolt Physics and a warning is thrown.
	const APPROX_ZERO: Vector3 = Vector3(0.00001, 0.00001, 0.00001)
	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(target, "scale", APPROX_ZERO, .2)
	tween.tween_callback(target.queue_free)
	await tween.finished

func _animate_boar_growing_up(_boar: Node3D):
	var tween := get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(_boar, "scale", Vector3(1.5,1.5,1.5), .4)
	_boar.rotate(Vector3.UP, .1)
	is_grown = true

func _on_exit_state() -> void:
	target = null
	node.finished_feeding.emit()
	particles.emitting = false
	if not is_grown:
		_animate_boar_growing_up(boar)
		heart_particles.emitting = true
		boar.finished_growing.emit()
