extends CanvasLayer

@onready var gold_acorn_manager = %GoldAcornManager
@onready var label_gold_acorn_count = $Control/PanelContainer/MarginContainer/HBoxContainer/GoldAcornCount

func _ready():
	label_gold_acorn_count.text = "0" + "/" + str(gold_acorn_manager.total_acorns)

func _update_label_gold_acorn_count(collected_acorns) ->  void:
	label_gold_acorn_count.text = str(gold_acorn_manager.collected_acorns) + "/" + str(gold_acorn_manager.total_acorns)
