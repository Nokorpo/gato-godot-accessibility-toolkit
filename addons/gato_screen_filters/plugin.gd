@tool
extends EditorPlugin

const SINGLETON_SCENE_FILE: StringName = "controller/ui_injector_service.gd"

func _enter_tree():
	add_autoload_singleton("GatoScreenFilters", SINGLETON_SCENE_FILE)

func _exit_tree():
	remove_autoload_singleton("GatoScreenFilters")
