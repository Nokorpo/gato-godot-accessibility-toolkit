@tool
extends Node

@export
var enabled: bool = true:
	set(value):
		enabled = value
		_update_materials.call_deferred()

func _enter_tree() -> void:
	_update_materials.call_deferred()

func _exit_tree() -> void:
	for node in get_parent().find_children("", "MeshInstance3D"):
		_remove_overriden_material(node)

func _update_materials():
	for node in get_parent().find_children("", "MeshInstance3D"):
		if enabled and FeatureFlags.get("graphics_quality") == FeatureFlags.GraphicsQualityOptions.LOW:
			_add_overriden_material(node)
		else:
			_remove_overriden_material(node)

func _add_overriden_material(mesh: MeshInstance3D) -> void:
	var material := mesh.get_active_material(0)
	var path := _get_low_graphics_version(material.resource_path)
	if FileAccess.file_exists(path):
		mesh.set_surface_override_material(0, load(path).duplicate())
		mesh.notify_property_list_changed()

func _get_low_graphics_version(path: String) -> StringName:
	var path_parts: PackedStringArray = path.split("/")
	var file: PackedStringArray = path_parts[-1].split(".")
	var file_name: String = file[0]
	var extension: String = file[1]
	var file_dir: String = "/".join(path_parts.slice(0, -1))

	return file_dir+"/"+file_name+"_low."+extension

func _remove_overriden_material(mesh: MeshInstance3D) -> void:
	var material := mesh.get_surface_override_material(0)
	if material != null and material.resource_name.ends_with("_low"):
		mesh.set_surface_override_material(0, null)
		mesh.notify_property_list_changed()
