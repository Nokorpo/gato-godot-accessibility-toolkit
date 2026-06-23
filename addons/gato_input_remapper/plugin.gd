## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
@tool
extends EditorPlugin


func _enter_tree():
	add_autoload_singleton("InputRemapper", "res://addons/input_remapper/service/input_remapper_service.gd")

func _exit_tree():
	remove_autoload_singleton("InputRemapper")
