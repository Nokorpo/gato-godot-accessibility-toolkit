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
		var gato: Node = add_child_autofree(load("res://modules/characters/gato/gato.tscn").instantiate())

		#WHEN
		_sender.action_down("move_down").hold_for(1)
		await(_sender.idle)

		#THEN
		var state_machine: StateMachine = gato.find_child("StateMachine")
		var walk_state: GatoWalkState = state_machine.find_child("WalkState")
		assert_eq(state_machine.current_state, walk_state, "Gato is not in Walk state")
