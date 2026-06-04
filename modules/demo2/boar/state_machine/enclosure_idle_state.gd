extends StateMachineState
class_name EnclosureBoarIdleState

@export var mesh: BoarMesh

func _on_enter_state() -> void:
	mesh.play_animation.call_deferred(BoarMesh.Animations.IDLE)

func tick() -> void:
	var acorn = %AcornDetection.get_acorn_in_range()
	if acorn != null:# and acorn is Acorn:
		state_machine.change_state(EnclosureBoarFollowingAcornState)
