extends GutTest

func test_state_machine_exists():
	#GIVEN
	var gato: Node = add_child_autofree(load("res://modules/characters/gato/gato.tscn").instantiate())
	
	#WHEN
	var state_machine: Node = gato.find_child("StateMachine")
	
	#THEN
	assert_not_null(state_machine, "Gato StateMachine does not exists")
