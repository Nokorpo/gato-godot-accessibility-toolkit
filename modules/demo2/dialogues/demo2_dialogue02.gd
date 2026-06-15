## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends Node

@export var dialogue: DialogueContainer

func _on_gato_boar_selected(_enclosure):
	await get_tree().create_timer(0.5).timeout
	DialogueSystem.load_dialogue(dialogue)
	queue_free()
