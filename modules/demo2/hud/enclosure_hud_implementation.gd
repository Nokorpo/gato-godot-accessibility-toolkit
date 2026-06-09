## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
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

func set_zoom_level(zoom_level: float) -> void:
	get_child(0).scale = Vector2(zoom_level/100, zoom_level/100)
