extends Node2D

func _ready() -> void:
	if not OS.has_feature("editor"):
		hide()

func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()
