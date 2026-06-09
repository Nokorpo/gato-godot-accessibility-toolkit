## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends CanvasLayer

signal hud_position_changed(position: EnclosureHUD.HUD)
signal hud_zoom_level_changed(zoom_level: float)

@export var position_control: RowNavigationContainer

func get_button_text() -> String:
	return "Personalización HUD"

func grab_focus() -> void:
	position_control.grab_focus()

func _on_hud_position_changed(position: EnclosureHUD.HUD) -> void:
	hud_position_changed.emit(position)

func _on_hud_zoom_level_changed(zoom_level: float) -> void:
	hud_zoom_level_changed.emit(zoom_level)
