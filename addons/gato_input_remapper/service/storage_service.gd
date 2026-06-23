## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends RefCounted
## This class loads and stores control schemes and input configuration defined in InputRemapper. It
## stores all data in "user://input.data" by default.[br][br]
##
## The format is a mix of custom JSON and Godot's native to json conversion (for more information, see
## [url=https://docs.godotengine.org/en/stable/classes/class_json.html#class-json-method-from-native]this link[/url]).

const DEFAULT_EVENTS := ["ui_accept", "ui_select", "ui_cancel", "ui_focus_next", "ui_focus_prev", "ui_left", "ui_right", "ui_up", "ui_down", "ui_page_up", "ui_page_down", "ui_home", "ui_end", "ui_cut", "ui_copy", "ui_paste", "ui_undo", "ui_redo", "ui_text_completion_query", "ui_text_completion_accept", "ui_text_completion_replace", "ui_text_newline", "ui_text_newline_blank", "ui_text_newline_above", "ui_text_indent", "ui_text_dedent", "ui_text_backspace", "ui_text_backspace_word", "ui_text_backspace_word.macos", "ui_text_backspace_all_to_left", "ui_text_backspace_all_to_left.macos", "ui_text_delete", "ui_text_delete_word", "ui_text_delete_word.macos", "ui_text_delete_all_to_right", "ui_text_delete_all_to_right.macos", "ui_text_caret_left", "ui_text_caret_word_left", "ui_text_caret_word_left.macos", "ui_text_caret_right", "ui_text_caret_word_right", "ui_text_caret_word_right.macos", "ui_text_caret_up", "ui_text_caret_down", "ui_text_caret_line_start", "ui_text_caret_line_start.macos", "ui_text_caret_line_end", "ui_text_caret_line_end.macos", "ui_text_caret_page_up", "ui_text_caret_page_down", "ui_text_caret_document_start", "ui_text_caret_document_start.macos", "ui_text_caret_document_end", "ui_text_caret_document_end.macos", "ui_text_caret_add_below", "ui_text_caret_add_below.macos", "ui_text_caret_add_above", "ui_text_caret_add_above.macos", "ui_text_scroll_up", "ui_text_scroll_up.macos", "ui_text_scroll_down", "ui_text_scroll_down.macos", "ui_text_select_all", "ui_text_select_word_under_caret", "ui_text_select_word_under_caret.macos", "ui_text_add_selection_for_next_occurrence", "ui_text_skip_selection_for_next_occurrence", "ui_text_clear_carets_and_selection", "ui_text_toggle_insert_mode", "ui_menu", "ui_text_submit", "ui_unicode_start", "ui_graph_duplicate", "ui_graph_delete", "ui_filedialog_up_one_level", "ui_filedialog_refresh", "ui_filedialog_show_hidden", "ui_swap_input_direction"]

## Defines the default settings file path environment variable name. If you need to change the path
## of the default settings file, use this environment variable or pass it to Godot when running it.
const DEFAULT_FILE_ENVVAR := "DEFAULT_INPUT_REMAPPER_FILE_PATH"

## Defines the default settings file path. When the project/game is open for the first time, it will
## initialize the input with the data in this file. If you need to use a different file, pass the
## new path by setting the environment variable [code]"DEFAULT_INPUT_REMAPPER_FILE_PATH"[/code].
## See [member DEFAULT_FILE_ENVVAR].
const DEFAULT_FILE_PATH := "res://addons/gato_input_remapper/default_input.data"

## Defines where the settings will be stored once changes are saved. This is also the path that will
## be used to reload the settings next time the game runs.
var settings_file := "user://input.data"

var control_scheme_script: Script = load("res://addons/gato_input_remapper/model/control_scheme.gd")

## Initializes the settings file with a default config if it's empty on startup.
func _init():
	if verify_config_file(settings_file) == Error.OK:
		return

	var default_file_path := OS.get_environment(DEFAULT_FILE_ENVVAR)
	if not default_file_path:
		default_file_path = DEFAULT_FILE_PATH

	DirAccess.copy_absolute(default_file_path, settings_file)

## Checks that the configuration file can be loaded correctly. If the file doesn't exist, cannot be
## parsed into JSON or the reading results in an empty list of control schemes, it returns an error.
func verify_config_file(file_path: Variant = null) -> Error:
	var config_file := settings_file
	if file_path != null:
		config_file = file_path

	if not FileAccess.file_exists(config_file):
		printerr("GATO Input Remapper: No control scheme could be loaded. Configuration file could not be found.")
		return Error.ERR_FILE_NOT_FOUND

	var file = FileAccess.open(config_file, FileAccess.READ)
	var file_contents := file.get_as_text()
	var json: Variant = JSON.parse_string(file_contents)
	if json == null:
		printerr("Error: no control scheme could be loaded. Configuration file could not be parsed.")
		return Error.ERR_FILE_CORRUPT

	var data = load_input_config_from_json(json)
	if data == null or data.is_empty():
		printerr("Error: no control scheme could be loaded. Control scheme list was empty.")
		return Error.ERR_FILE_CORRUPT
	file.close()
	return Error.OK

## If the settings file is not found, it needs to be generated for the plugin to work. This method
## generated the settings file with the Input Map defined in the project.
func initialized_file_with_input_map(file_path: Variant = null):
	for action in InputMap.get_actions():
		if action not in DEFAULT_EVENTS:
			pass

## Loads the input map configuration from a file. If no argument is passed, it will load the
## configuration from "user://input.data".
func load_input_config_from_file(file_path: Variant = null) -> Array[GatoControlScheme]:
	var config_file := settings_file
	if file_path != null:
		config_file = file_path

	if not FileAccess.file_exists(config_file):
		push_warning("The Gato Input Remapper config file does not exist. Please, create one or the plugin will not work.")
		return []

	var file = FileAccess.open(config_file, FileAccess.READ)
	var file_contents := file.get_as_text()
	var json: Dictionary = JSON.parse_string(file_contents)
	var data = load_input_config_from_json(json)
	file.close()
	return data

## Loads the input map configuration from a json dictionary.
func load_input_config_from_json(json: Dictionary) -> Array[GatoControlScheme]:
	var schemes: Array[GatoControlScheme] = []
	if not json.has("control_schemes"):
		push_error("The stored input configuration is not valid. It should start with a list a of control schemes.")
		return []
	for item in json["control_schemes"]:
		if not item["type"] == "control_scheme":
			push_error("The stored input configuration has a broken control scheme.")
			continue
		var scheme: GatoControlScheme = control_scheme_script.new_from_dict(item)
		schemes.append(scheme)
	return schemes

## Stores the control schemes modified by the user in a file. If no argument for the file is passed,
## it will store the configuration in "user://input.data".
func store_input_config(input_config: Variant, file_path: Variant = null):
	var config_file := settings_file
	if file_path != null:
		config_file = file_path

	if not DirAccess.dir_exists_absolute(config_file.get_base_dir()):
		DirAccess.make_dir_recursive_absolute(config_file.get_base_dir())

	var schemes_to_store = []
	for scheme in input_config:
		schemes_to_store.append(scheme.get_as_dict())
	var dict: Dictionary = { "control_schemes": schemes_to_store }

	var text: String = JSON.stringify(dict, "\t")
	var file := FileAccess.open(config_file, FileAccess.WRITE)
	file.store_string(text)
	file.close()
