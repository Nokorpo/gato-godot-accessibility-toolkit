## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends CanvasLayer

@onready var _blur: Control = $BackgroundBlur
@onready var _ui_offset: Control = $Control/Offset
@onready var _ui_content: Control = _ui_offset.get_child(0)

var _initial_offset_position: Vector2
var _tween: Tween = null

func _ready() -> void:
	var ui_size: float = _ui_content.get_rect().size.x
	_ui_offset.position.x = ui_size * 0.875
	_initial_offset_position = _ui_offset.position

func _show_hud() -> void:
	if _tween:
		_tween.stop()
	_tween = create_tween()
	_tween.set_ease(Tween.EASE_OUT)
	_tween.set_trans(Tween.TRANS_BOUNCE)
	_tween.tween_property(_ui_offset, "position", Vector2.ZERO, 1.)

func _hide_hud() -> void:
	if _tween:
		_tween.stop()
	_tween = create_tween()
	_tween.set_ease(Tween.EASE_OUT)
	_tween.set_trans(Tween.TRANS_BOUNCE)
	_tween.tween_property(_ui_offset, "position", _initial_offset_position, 1.)

func _input(event: InputEvent) -> void:
	if (event.is_action("change_filter_right") or event.is_action("change_filter_left")) \
		and event.is_pressed():
		%BlurButton._on_button_toggled(not _blur.is_enabled())

func _show_hint() -> void:
	if _tween:
		_tween.stop()
	_tween = create_tween()
	_tween.set_ease(Tween.EASE_OUT)
	_tween.set_trans(Tween.TRANS_EXPO)
	_tween.tween_property(_ui_offset, "position", Vector2(_initial_offset_position.x - 60, 0), 1.)

func _hide_hint() -> void:
	if _tween:
		_tween.stop()
	_tween = create_tween()
	_tween.set_ease(Tween.EASE_OUT)
	_tween.set_trans(Tween.TRANS_EXPO)
	_tween.tween_property(_ui_offset, "position", _initial_offset_position, 1.)
