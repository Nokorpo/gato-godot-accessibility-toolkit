extends StateMachineState
class_name GatoJumpState

@export var mesh: GatoMesh
@export var max_jumps: int = 2

var remaining_jumps: int = max_jumps

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called when the state machine changes to this state.
func _on_enter_state() -> void:
	if not DebugMenu.enable_infinite_jumps:
		remaining_jumps -= 1
	node.jump()
	mesh.play_animation(GatoMesh.Animations.JUMP)

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
	if Input.is_action_just_pressed("jump") and remaining_jumps > 0:
		state_machine.change_state(GatoJumpState)
	if active:
		if node.velocity.y <= 0:
			mesh.play_animation(GatoMesh.Animations.JUMP_FALL)
		if node.is_on_floor():
			remaining_jumps = max_jumps
			if node.velocity.length() >= 0.2:
				state_machine.change_state(GatoWalkState)
			else:
				state_machine.change_state(GatoIdleState)
