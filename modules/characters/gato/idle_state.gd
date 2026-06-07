## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
class_name GatoIdleState
extends StateMachineState

@export var mesh: GatoMesh

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called when the state machine changes to this state.
func _on_enter_state() -> void:
	mesh.play_animation(GatoMesh.Animations.IDLE)


# Called when the state machine changes from this state to another one.
func _on_exit_state() -> void:
	pass # Replace with function body.

# Called every time the state machine's tick() method is called.
func tick() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass # Replace with function body.

# Called every physics frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if active:
		if Input.is_action_just_pressed("jump"):
			state_machine.change_state(GatoJumpState)

		var horizontal_velocity := Vector2(node.velocity.x, node.velocity.z)
		if horizontal_velocity.length() >= 0.2:
			state_machine.change_state(GatoWalkState)
