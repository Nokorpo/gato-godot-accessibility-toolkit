## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
class_name GatoWalkState
extends StateMachineState

@export var mesh: GatoMesh
@export var walk_partricles: GPUParticles3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called when the state machine changes to this state.
func _on_enter_state() -> void:
	mesh.play_animation(GatoMesh.Animations.WALK)
	walk_partricles.emitting = true

# Called when the state machine changes from this state to another one.
func _on_exit_state() -> void:
	walk_partricles.emitting = false

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
		if node.velocity.length() < 0.2:
			state_machine.change_state(GatoIdleState)
		if abs(node.velocity.y) >= 0.2:
			mesh.play_animation(GatoMesh.Animations.JUMP_FALL)
