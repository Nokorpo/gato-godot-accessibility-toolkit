extends Control

@export var enclosure_to_node_map: Dictionary[Enclosure.EnclosureType, Control]

var _current_selection: Enclosure.EnclosureType = Enclosure.EnclosureType.A

func _ready() -> void:
	for node: Control in enclosure_to_node_map.values():
		node.hide()
	enclosure_to_node_map[_current_selection].show()

func set_enclosure(assigned_enclosure: Enclosure.EnclosureType) -> void:
	enclosure_to_node_map[_current_selection].hide()
	_current_selection = assigned_enclosure
	enclosure_to_node_map[_current_selection].show()
