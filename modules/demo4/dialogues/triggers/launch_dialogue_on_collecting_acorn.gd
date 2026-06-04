## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends Node

@export var dialogue: Array[DialogueContainer]

func _ready():
	%GoldAcornManager.collected_goldacorn.connect(launch_dialog)

func launch_dialog(collected_acorns) -> void:
	DialogueSystem.load_dialogue(dialogue[collected_acorns-1])
