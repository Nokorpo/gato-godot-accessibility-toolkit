extends Node3D

signal collected_all_goldacorns

var collected_acorns: float = 0
var total_acorns: int = 4

func _on_gold_acorn_goldacorn_collected() -> void:
	collected_acorns += 1
	if collected_acorns >= total_acorns:
		collected_all_goldacorns.emit()
