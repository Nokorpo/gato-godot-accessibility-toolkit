extends Node
class_name StateMachineState

var active: bool
var state_machine: StateMachine
var node: Node

func _start(_state_machine: StateMachine, _node: Node) -> void:
	state_machine = _state_machine
	node = _node

func _on_enter_state() -> void: pass
func _on_exit_state() -> void: pass

# build different states:
# - normal: no changes
# - fired_up:
#    - on enter: replace bat mesh, toggle fire particles on
#    - on exit: replace bat mesh to normal, toggle fire particles off
