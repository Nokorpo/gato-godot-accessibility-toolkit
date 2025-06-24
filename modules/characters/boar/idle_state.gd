extends StateMachineState
class_name BoarIdleState

func tick() -> void:
	var acorn = %AcornDetection.get_acorn_in_range()
	if acorn != null:# and acorn is Acorn:
		state_machine.change_state(BoarFollowingAcornState)
