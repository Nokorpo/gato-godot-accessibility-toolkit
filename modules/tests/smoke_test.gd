#!/usr/bin/env -S godot -s
extends SceneTree

func _init():
	await root.ready
	var all_scenes := SceneFileFinder.new().get_scene_files()
	print("Testing %d scenes." % all_scenes.size())
	for scene in all_scenes:
		print(" - Testing %s..." % scene)
		var result := await test_scene(scene)
	print("Test finished, check for errors")
	await create_timer(.5).timeout
	quit()

func test_scene(path: String) -> Error:
	var packed: PackedScene = load(path)
	var instantiated_scene: Node = packed.instantiate()
	root.add_child(instantiated_scene)
	await self.process_frame
	root.remove_child(instantiated_scene)
	instantiated_scene.queue_free()
	return Error.OK


class SceneFileFinder extends Object:

	const FILE_EXTENSION := ".tscn"

	var exclusion_regexes: Array[RegEx] = []
	var all_scenes: PackedStringArray

	static func _append_path(path: String, file: String) -> String:
		if path == "res://":
			return "res://%s" % file
		else:
			return "%s/%s" % [path, file]

	static func _transform_glob_expansion_to_regex(glob_pattern: String) -> RegEx:
		var regex := RegEx.new()
		regex.compile(glob_pattern.replace("*", "[^/]+").replace("**", ".+"))
		return regex

	func _init():
		_initialize_exclusion_list()

	func _initialize_exclusion_list() -> void:
		for pattern in OS.get_cmdline_user_args():
			exclusion_regexes.append(_transform_glob_expansion_to_regex(pattern))

	func is_ignored(path: String) -> bool:
		for regex in exclusion_regexes:
			if regex.search(path):
				return true
		return false

	func get_scene_files(path: String = "res://",  files := []) -> PackedStringArray:
		for file in DirAccess.get_files_at(path):
			var file_path := _append_path(path, file)
			if file.ends_with(FILE_EXTENSION) and not is_ignored(file_path):
				files.append(file_path)

		var directories := DirAccess.get_directories_at(path)
		for dir in directories:
			var new_path: String = _append_path(path, dir)
			files.append_array(get_scene_files(_append_path(path, dir), []))

		return files
