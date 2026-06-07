## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends CanvasLayer

@onready var gold_acorn_manager = %GoldAcornManager
@onready var label_gold_acorn_count = $Control/PanelContainer/MarginContainer/HBoxContainer/GoldAcornCount

func _ready():
	label_gold_acorn_count.text = "0" + "/" + str(gold_acorn_manager.total_acorns)

func _update_label_gold_acorn_count(collected_acorns) ->  void:
	label_gold_acorn_count.text = str(gold_acorn_manager.collected_acorns) + "/" + str(gold_acorn_manager.total_acorns)
