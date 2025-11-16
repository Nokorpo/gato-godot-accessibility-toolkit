@tool
extends EditorPlugin


func _enter_tree():
	add_autoload_singleton("GatoScreenFilters", "res://addons/input_remapper/service/input_remapper_service.gd")

func _exit_tree():
	remove_autoload_singleton("GatoScreenFilters")
