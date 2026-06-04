## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends CanvasLayer

@onready var level_completion_check = $"../LevelCompletionCheck"
@onready var label_fed_boar_count = $Control/PanelContainer/MarginContainer/HBoxContainer/FedBoarCount

func _ready():
	label_fed_boar_count.text = "0" + "/" + str(level_completion_check.total_boars)

func update_fed_boar_count_label():
	label_fed_boar_count.text = str(level_completion_check.fed_boars) + "/" + str(level_completion_check.total_boars)
