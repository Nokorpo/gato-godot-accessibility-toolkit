extends GutTest

class TestGato extends GutTest:

	func test_state_machine_exists():
		#GIVEN
		var gato: Node = add_child_autofree(load("res://modules/characters/gato/gato.tscn").instantiate())
		
		#WHEN
		var state_machine: Node = gato.find_child("StateMachine")
		
		#THEN
		assert_not_null(state_machine, "Gato StateMachine does not exists")

class TestGatoInput extends GutTest:

	var _sender = InputSender.new(Input)

	func after_each():
		_sender.release_all()
		_sender.clear()

	func test_player_walk_state():
		#GIVEN
		var gato: Node3D = add_child_autofree(load("res://modules/characters/gato/gato.tscn").instantiate())

		#WHEN
		_sender.action_down("move_down").hold_for(1)
		await(_sender.idle)

		#THEN
		var state_machine: StateMachine = gato.find_child("StateMachine")
		var walk_state: GatoWalkState = state_machine.find_child("WalkState")
		assert_eq(state_machine.current_state, walk_state, "Gato is not in Walk state")

	func test_player_rotates():
		#GIVEN
		var gato: Node3D = add_child_autofree(load("res://modules/characters/gato/gato.tscn").instantiate())

		#WHEN
		_sender.action_down("move_right").action_down("move_down").hold_for(1)
		await(_sender.idle)

		#THEN
		var horizontal_movement := Vector2(gato.global_position.x, gato.global_position.z)
		assert_gte(horizontal_movement, Vector2(1.0, 1.0), "Gato didn't move to the bottom right")
		
		var rotation_pivot: Node3D = gato.find_child("RotationPivot")
		var gato_forward := rotation_pivot.global_transform.basis.z
		var down_right := Vector3(1.0, 0.0, 1.0).normalized()
		assert_gte(gato_forward.dot(down_right), 0.95, "Gato didn't rotate to look to the bottom right")

	func test_player_jump_state():
		#GIVEN
		var gato: Node = add_child_autofree(load("res://modules/characters/gato/gato.tscn").instantiate())

		#WHEN
		_sender.action_down("jump").wait_frames(2)
		await(_sender.idle)

		#THEN
		var state_machine: StateMachine = gato.find_child("StateMachine")
		var jump_state: GatoJumpState = state_machine.find_child("JumpState")
		assert_eq(state_machine.current_state, jump_state, "Gato is not in Jump state")
		
