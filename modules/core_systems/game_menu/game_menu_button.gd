## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
class_name GameMenuButton
extends Button

const FOCUSED_TEXT_COLOR := Color("08001c")

func _on_focus_entered() -> void:
	add_theme_color_override("font_focus_color", FOCUSED_TEXT_COLOR)
	add_theme_color_override("font_hover_color", FOCUSED_TEXT_COLOR)

func _on_focus_exited() -> void:
	remove_theme_color_override("font_focus_color")
	remove_theme_color_override("font_hover_color")

func _on_mouse_entered() -> void:
	grab_focus()
