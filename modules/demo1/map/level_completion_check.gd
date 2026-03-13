extends Node

signal level_finished

@export var boar_list: Node3D

var total_boars: int
var fed_boars: int = 0

func _ready() -> void:
	total_boars = boar_list.get_child_count()
	for boar: Boar in boar_list.get_children():
		boar.finished_feeding.connect(_another_one_bites_the_corn)

func _another_one_bites_the_corn() -> void:
	fed_boars += 1
	if fed_boars >= total_boars:
		level_finished.emit()
