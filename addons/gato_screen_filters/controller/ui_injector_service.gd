## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends Node
## This service creates the Screen Filters UI and injects it in the running
## game.

const UI_SCENE_UID: StringName = "uid://14lvyt4uefey"
var ui: CanvasLayer = null

func _ready() -> void:
	ui = (load(UI_SCENE_UID) as PackedScene).instantiate()
	ui.keycode_to_toggle_visibility = OS.find_keycode_from_string(get_key_string_from_config())
	get_tree().root.add_child.call_deferred(ui)

# TODO extract to model folder
func get_key_string_from_config() -> String:
	var config := ConfigFile.new()
	config.load("res://addons/gato_screen_filters/plugin.cfg")
	return config.get_value("default_variables", "key_to_toggle_ui_visibility", "F6")
