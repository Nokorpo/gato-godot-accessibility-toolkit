@tool
extends Node

@export_tool_button("asdf")
var button: Callable = func(): _ready()

func _ready() -> void:
	_update_materials.call_deferred()

func _update_materials():
	for node in get_parent().find_children("", "MeshInstance3D"):
		var mesh: MeshInstance3D = node
		if FeatureFlags.get("graphics_quality") == FeatureFlags.GraphicsQualityOptions.LOW:
			var material := mesh.get_active_material(0)
			var path := _get_low_graphics_version(material.resource_path)
			if FileAccess.file_exists(path):
				mesh.set_surface_override_material(0, load(path))
		else:
			var material := mesh.get_surface_override_material(0)
			if material != null and material.resource_path.ends_with("_low.tres"):
				mesh.set_surface_override_material(0, null)

func _get_low_graphics_version(path: String) -> StringName:
	var path_parts: PackedStringArray = path.split("/")
	var file: PackedStringArray = path_parts[-1].split(".")
	var file_name: String = file[0]
	var extension: String = file[1]
	var file_dir: String = "/".join(path_parts.slice(0, -1))

	return file_dir+"/"+file_name+"_low."+extension
