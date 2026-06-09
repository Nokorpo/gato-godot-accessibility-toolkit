## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends CanvasLayer

func get_button_text() -> String:
	return "Controles"

func grab_focus() -> void:
	$InputRemapperUi.grab_focus()
