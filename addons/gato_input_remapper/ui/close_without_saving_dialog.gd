## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
##
## A Control node to use when a user tries to close the Input Remapper with
## unsaved changes. It lets the user decide whether they want to go back,
## save the changes or discard them.
extends Control

## Reference to the InputRemapperUI Control node.
@onready var input_remapper_ui: InputRemapperUI

@onready var _accept_audio: AudioStreamPlayer = $AcceptAudioStreamPlayer
@onready var _cancel_audio: AudioStreamPlayer = $CancelAudioStreamPlayer

## Emitted when this dialog appears.
signal appeared
## Emitted when this dialog is closed.
signal disappeared

func _ready() -> void:
	if get_parent() is InputRemapperUI:
		input_remapper_ui = get_parent()
	visibility_changed.connect(_on_visibility_changed)
	get_child(0).modulate = Color.TRANSPARENT
	$PanelContainer/VBoxContainer/RowNavigationContainer/BackButton.pressed.connect(_on_back)
	$PanelContainer/VBoxContainer/RowNavigationContainer2/SaveAndExitButton.pressed.connect(_on_save_and_exit)
	$PanelContainer/VBoxContainer/RowNavigationContainer3/ExitWithoutSavingButton.pressed.connect(_on_exit_without_saving)

func _on_visibility_changed():
	if visible:
		create_tween().tween_property(get_child(0), "modulate", Color.WHITE, .25)
		appeared.emit()
	else:
		create_tween().tween_property(get_child(0), "modulate", Color.TRANSPARENT, .25)
		disappeared.emit()

func _on_back() -> void:
	visible = false
	_cancel_audio.play()

func _on_save_and_exit() -> void:
	_accept_audio.play()
	input_remapper_ui.save_changes()
	input_remapper_ui.close()

func _on_exit_without_saving() -> void:
	_cancel_audio.play()
	input_remapper_ui.close()
