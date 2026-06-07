## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends Node
## This node launches a dialogue when all the boars under the boar_list node have been fed.

const DEMO_SELECTOR_PATH := "res://modules/demo_selector/demo_selector.tscn"

@onready var level_completion_node: Node = $"../../LevelCompletionCheck"

@export var demo_completed_screen: Node
@export var dialogue: DialogueContainer

func _ready():
	level_completion_node.fed_all_boars.connect(launch_dialog)

func launch_dialog() -> void:
	DialogueSystem.load_dialogue(dialogue)
	await DialogueSystem.dialogue_finished
	demo_completed_screen.show_screen()
