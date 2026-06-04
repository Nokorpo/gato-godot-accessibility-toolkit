class_name EnclosureBoar
extends Boar

@export var assigned_enclosure: Enclosure.EnclosureType

var _enclosure_reached: bool = false

func set_enclosure_as_reached():
	if not _enclosure_reached:
		_enclosure_reached = true
		$StateMachine.change_state(EnclosureBoarFoundEnclosureState)
		finished_growing.emit()
