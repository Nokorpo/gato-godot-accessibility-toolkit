## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends Node

signal finished

@export var dialogue: DialogueContainer

var used_actions: Dictionary[StringName, bool] = {
	"move_up": false,
	"jump": false,
	"launch_item": false,
}

func _process(_delta: float) -> void:
	for action in used_actions.keys():
		if not used_actions[action] and Input.is_action_just_pressed(action):
			used_actions[action] = true

	if _all_actions_pressed():
		get_tree().create_timer(3).timeout.connect(_launch_dialogue_and_free)
		finished.emit()
		process_mode = Node.PROCESS_MODE_DISABLED

func _all_actions_pressed() -> bool:
	return used_actions.values().all(func(it: bool): return it)

func _launch_dialogue_and_free() -> void:
	DialogueSystem.load_dialogue(dialogue)
	queue_free()
