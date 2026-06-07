## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends Node

signal fed_all_boars
signal level_finished
signal update_hud_count

@export var boar_list: Node3D

var total_boars: int
var fed_boars: int = 0

func _ready() -> void:
	total_boars = boar_list.get_child_count()
	for boar in boar_list.get_children():
		boar.finished_growing.connect(_another_one_bites_the_corn)
		if boar.has_signal("decreased"):
			boar.decreased.connect(_another_one_mismatch_the_corn)
	update_hud_count.emit()

func _another_one_bites_the_corn() -> void:
	fed_boars += 1
	update_hud_count.emit()
	if fed_boars >= total_boars:
		fed_all_boars.emit()
		await DialogueSystem.dialogue_finished
		level_finished.emit()

func _another_one_mismatch_the_corn() -> void:
	fed_boars -= 1
	update_hud_count.emit()

func change_boar_meshes():
	boar_list.hide()
	boar_list = $"../AccessibleBoars"
	boar_list.show()
