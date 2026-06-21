## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends Node
## This node launches a dialogue when the player enters an Area 3D Node called "UseBoarAsPlaformDialoueTrigger".

@export var dialogue: DialogueContainer

func launch_dialog():
	DialogueSystem.load_dialogue(dialogue)
	queue_free()

func _on_use_boar_as_plaform_dialoue_trigger_body_entered(body):
	if body is Gato:
		await get_tree().create_timer(1.0).timeout # Give player some time to test controls
		launch_dialog()
