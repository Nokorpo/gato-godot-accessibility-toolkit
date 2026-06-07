## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
#!/usr/bin/env -S godot -s
extends SceneTree
## This script is a smoke test that opens and closes all scenes in a project.[br][br]
##
## An example execution of this script might look like this:
##[codeblock]
## --- RUN TESTS ---
## Testing 2 scenes.
## - Testing scene_name.tscn...
## ERROR: error message
## WARNING: warning message
## ...
## - Testing scene_name2.tscn...
## ERROR: error message
## ...
##[/codeblock]
## [br][br]
##
## These errors and warnings can be parsed by a shell script running this test.
## Then it can use the generated data to, for example: [br]
## • Generate a summary of erors and warnings [br]
## • Send this summary as a Discord message [br]
## • Re-run the tests to discard any failures was due to flakiness

func _init():
	await root.ready
	var all_scenes := SceneFileFinder.new().get_scene_files()
	print("Testing %d scenes." % all_scenes.size())
	for scene in all_scenes:
		print(" - Testing %s..." % scene)
		var result := await test_scene(scene)
	print("Test finished, check for errors")
	# Since Godot doesn't have a print_flush() like function, we need to wait
	# for the print to reach stdout before we close the test. Otherwise we
	# might miss some output.
	await create_timer(.5).timeout
	quit()

## Loads the scene passed as an argument. Then, it waits for a frame so that
## errors and warnings have time to appear. Lastly, it removes the scene from
## the tree and frees it.
func test_scene(path: String) -> Error:
	var packed: PackedScene = load(path)
	var instantiated_scene: Node = packed.instantiate()
	root.add_child(instantiated_scene)
	await self.process_frame
	root.remove_child(instantiated_scene)
	if is_instance_valid(instantiated_scene) and not instantiated_scene.is_queued_for_deletion():
		instantiated_scene.queue_free()
	return Error.OK


## Finds scene files (ending in ".tscn") to run the smoke tests on.[br][br]
##
## Additionally, you can configure it with a list of ignored files and folders
## by passing a list of ignored files from the terminal as an argument. For
## example, the following command will ignore the file [code]scene1.tscn[/code]
## at the root of the project:[br]
## [code]godot -s smoke_test.gd -- "res://scene1.tscn"[/code][br][br]
##
## It also supports glob expansion with asterisk (*) meaning any file name, and
## double asterisk (**) meaning any path. For example, the following command
## will ignore all files inside a [code]feature1[/code] folder whose name
## starts with [code]test_[/code]:[br]
## [code]godot -s smoke_test.gd -- "res://**/feature1/test_*.tscn"[/code]
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

	## Checks whether the passed file path is ignored with the current configured exclusions.
	func is_ignored(path: String) -> bool:
		for regex in exclusion_regexes:
			if regex.search(path):
				return true
		return false

	## Returns a list of scene files starting at the [code]path[/code] folder
	## and ignoring any excluded file.
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
