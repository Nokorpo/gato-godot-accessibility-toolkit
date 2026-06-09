## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
@tool
extends EditorPlugin

const SINGLETON_SCENE_FILE: StringName = "text_to_speech.gd"

func _enter_tree():
	add_autoload_singleton("GatoTextToSpeech", SINGLETON_SCENE_FILE)

func _exit_tree():
	remove_autoload_singleton("GatoTextToSpeech")
