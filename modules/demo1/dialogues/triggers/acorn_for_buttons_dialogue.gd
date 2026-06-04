## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends Node
## This node represents a dialogue that is launched when a set of conditions are met:
## 1. When the player grabs an acorn, a timer of 6 minutes starts.
## 2. If the player uses the acorn on a button, the timer is dismissed.
## 3. Otherwise, when the 6 minutes are over, a dialogue is launched pointing to
## the acorn being usable to press the button.

@export var player: Gato
@export var first_button: Node3D
@export var dialogue: DialogueContainer

var timer: SceneTreeTimer

func _ready() -> void:
	first_button.button_activated.connect(prevent_dialogue_if_acorn_used)
	player.item_collected.connect(_start_timer)

func _start_timer(_item) -> void:
	timer = get_tree().create_timer(6*60)
	timer.timeout.connect(launch_dialog)

func _notification(what):
	if (what == NOTIFICATION_PREDELETE):
		# SceneTreeTimer cannot be stopped, so we must disable it by removing
		# all references to it (see `RefCounted`)
		if is_instance_valid(timer) and not timer.is_queued_for_deletion():
			timer.disconnect("timeout", launch_dialog)
			timer = null

func launch_dialog() -> void:
	DialogueSystem.load_dialogue(dialogue)
	queue_free()

func _is_acorn_pressing_button() -> bool:
	for item in first_button.item_list:
		if item is Acorn:
			return true
	return false

func prevent_dialogue_if_acorn_used() -> void:
	if _is_acorn_pressing_button():
		queue_free()
