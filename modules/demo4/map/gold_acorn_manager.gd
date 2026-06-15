## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends Node3D

signal collected_goldacorn(collected_acorns)
signal level_finished

var collected_acorns: int = 0
var total_acorns: int = 5

func _on_gold_acorn_goldacorn_collected() -> void:
	collected_acorns += 1
	collected_goldacorn.emit(collected_acorns)
	if collected_acorns >= total_acorns:
		await DialogueSystem.dialogue_finished
		level_finished.emit()
