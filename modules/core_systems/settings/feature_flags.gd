## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
@tool
extends Node

const CONFIG_FILE_PATH: StringName = "user://feature_flags.cfg"
const DEFAULT_CONFIG_FILE_PATH: StringName = "res://modules/core_systems/settings/feature_flags.cfg"
var config_file: ConfigFile

enum GraphicsQualityOptions { NORMAL, LOW }
var graphics_quality: GraphicsQualityOptions = GraphicsQualityOptions.NORMAL

func _ready() -> void:
	if not FileAccess.file_exists(CONFIG_FILE_PATH):
		print("Feature flag config file does not exist. Creating a file with the default configuration in \"%s\"" % CONFIG_FILE_PATH)
		var default_file = FileAccess.open(DEFAULT_CONFIG_FILE_PATH, FileAccess.READ)
		var content = default_file.get_as_text()
		var config = FileAccess.open(CONFIG_FILE_PATH, FileAccess.WRITE)
		config.store_string(content)

	config_file = ConfigFile.new()
	config_file.load(CONFIG_FILE_PATH)
	load_variables()

func load_variables():
	graphics_quality = GraphicsQualityOptions.get(config_file.get_value("graphics", "quality", "NORMAL"), GraphicsQualityOptions.NORMAL)
