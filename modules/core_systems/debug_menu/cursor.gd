## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends Node2D

func _ready() -> void:
	if not OS.has_feature("editor"):
		hide()

func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()
