## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends StateMachineState
class_name BoarIdleState

@export var mesh: BoarMesh

func _on_enter_state() -> void:
	mesh.play_animation.call_deferred(BoarMesh.Animations.IDLE)

func tick() -> void:
	var acorn = %AcornDetection.get_acorn_in_range()
	if acorn != null:# and acorn is Acorn:
		state_machine.change_state(BoarFollowingAcornState)
