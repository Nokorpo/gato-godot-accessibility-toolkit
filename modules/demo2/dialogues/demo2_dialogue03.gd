## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends Node

@export var boars_node: Node3D
@export var dialogue: DialogueContainer

func _ready():
	for boar:EnclosureBoar in boars_node.get_children():
		boar.connect("finished_growing", _activate_dialogue)

func _activate_dialogue():
	for boar:EnclosureBoar in boars_node.get_children():
		boar.disconnect("finished_growing", _activate_dialogue)
	DialogueSystem.load_dialogue(dialogue)
	queue_free()
