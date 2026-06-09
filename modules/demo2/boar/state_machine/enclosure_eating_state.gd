## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends StateMachineState
class_name EnclosureBoarEatingState

@onready var particles: CPUParticles3D = $"../../CPUParticles3D"
@onready var heart_particles: GPUParticles3D = $"../../HeartParticles"
var target = null
var boar: CharacterBody3D
@export var mesh: BoarMesh
@export var eating_time: float = 1.5

func _start(_state_machine: StateMachine, _node: Node) -> void:
	super(_state_machine, _node)
	boar = _node as CharacterBody3D

func _on_enter_state() -> void:
	mesh.play_animation(BoarMesh.Animations.EAT)
	particles.emitting = true
	await get_tree().create_timer(eating_time).timeout
	if is_instance_valid(target):
		await target.animate_acorn_disappearance()
	state_machine.call_deferred("change_state", EnclosureBoarIdleState)

#TODO move to acorn code


func _on_exit_state() -> void:
	target = null
	node.finished_feeding.emit()
	particles.emitting = false
