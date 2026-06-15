## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends CanvasLayer

@export var button_text: String = "Controles"

func get_button_text() -> String:
	return button_text

func grab_focus() -> void:
	get_child(0).grab_focus()
