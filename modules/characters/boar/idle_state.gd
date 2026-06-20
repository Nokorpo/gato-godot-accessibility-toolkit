## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends StateMachineState
class_name BoarIdleState

@export var mesh: BoarMesh
@export var raycast: RayCast3D

func _on_enter_state() -> void:
	mesh.play_animation.call_deferred(BoarMesh.Animations.IDLE)
	if raycast.is_colliding():
		var tween := create_tween()
		var new_position: Vector3 = node.position + node.to_local(raycast.get_collision_point())
		tween.tween_property(node, "position", new_position, 0.25)

func tick() -> void:
	var acorn = %AcornDetection.get_acorn_in_range()
	if acorn != null:# and acorn is Acorn:
		state_machine.change_state(BoarFollowingAcornState)
