## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends StateMachineState
class_name EnclosureBoarFoundEnclosureState

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
	mesh.play_animation(BoarMesh.Animations.IDLE)
	is_grown = true
	heart_particles.emitting = true
