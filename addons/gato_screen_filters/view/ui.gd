## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
##
## This is the Control that handles selecting the type of filter to use
## while playing the game. As of now, multiple types of color blindness
## and a black and white filter have been implemented. You can use the
## dropdown selector to choose the filter you want to use.
extends CanvasLayer

## The dropdown selector that contains the options the user can choose from.
## Selecting an option here should enable that filter. The "normal vision"
## option disabled the filter altogether.
@onready var option_button: OptionButton = $Panel/MarginContainer/VBoxContainer/ColorBlindness/OptionButton
## A reference to the material that contains the shader used to modify the
## colors on screen.
@onready var material: ShaderMaterial = $Filter.material

## Key used to toggle visibility of this menu. Pressing this key shows
## or hides this menu.
var keycode_to_toggle_visibility: Key

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == keycode_to_toggle_visibility:
		if event.is_pressed():
			visible = !visible

func _on_filter_selected(index: int) -> void:
	_set_filter_on_shader(index)

func _set_filter_on_shader(index: int) -> void:
	material.set_shader_parameter("type", index)
