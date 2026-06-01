@tool
extends Node

const CONFIG_FILE_PATH: StringName = "res://modules/core_systems/settings/feature_flags.cfg"
var config_file: ConfigFile

func _ready() -> void:
	config_file = ConfigFile.new()
	config_file.load(CONFIG_FILE_PATH)

func get_value(section: StringName, key: StringName, default: Variant = null) -> Variant:
	return config_file.get_value(section, key, default)

func get_boolean(section: StringName, key: StringName, default: bool = false) -> bool:
	return config_file.get_value(section, key, default) as bool

func get_flag(key: StringName, default: bool = false) -> bool:
	return get_boolean("feature_flags", key, default)

func get_string(section: StringName, key: StringName, default: String = "") -> String:
	return config_file.get_value(section, key, default) as String
