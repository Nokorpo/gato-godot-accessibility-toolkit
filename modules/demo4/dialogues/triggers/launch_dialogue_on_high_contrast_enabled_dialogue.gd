## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends Node

@export var high_contrast_node: Node
@export var dialogue: DialogueContainer

func _ready():
	await DialogueSystem.dialogue_finished
	await get_tree().create_timer(.5).timeout
	high_contrast_node.show_ui()

	await high_contrast_node.enabled
	await get_tree().create_timer(2).timeout
	DialogueSystem.load_dialogue(dialogue)
	queue_free()
