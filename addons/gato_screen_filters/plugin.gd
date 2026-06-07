## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
@tool
extends EditorPlugin

const SINGLETON_SCENE_FILE: StringName = "controller/ui_injector_service.gd"

func _enter_tree():
	add_autoload_singleton("GatoScreenFilters", SINGLETON_SCENE_FILE)

func _exit_tree():
	remove_autoload_singleton("GatoScreenFilters")
