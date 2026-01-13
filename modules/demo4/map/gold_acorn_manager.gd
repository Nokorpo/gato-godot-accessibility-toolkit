extends Node3D

signal collected_all_goldacorns

var collected_acorns: float = 0
var total_acorns: int = 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_gold_acorn_goldacorn_collected() -> void:
	collected_acorns += 1
	if collected_acorns >= total_acorns:
		emit_signal("collected_acorns")
