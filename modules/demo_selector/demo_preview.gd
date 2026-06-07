## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
class_name DemoPreview
extends Control

signal demo_pressed(data: DemoData)

@export var data: DemoData
var _hover_tween: Tween

func _ready() -> void:
	%PreviewImage.texture = data.image
	%DemoTitle.text = data.title
	%Description.text = data.description
	%Hover.modulate = Color.TRANSPARENT
	_on_focus_exited()
	mouse_entered.connect(_on_mouse_entered)
	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)
	gui_input.connect(_on_gui_input)

func _on_pressed() -> void:
	demo_pressed.emit(data)

func _on_gui_input(event: InputEvent) -> void:
	if event.is_pressed():
		if event is InputEventMouseButton or event.is_action("ui_accept"):
			_on_pressed()

func _on_focus_entered() -> void:
	%FocusPanel.self_modulate.a = 1
	_show_hover()

func _on_focus_exited() -> void:
	var panel: Control = get_node_or_null("%FocusPanel")
	if is_instance_valid(panel) and not panel.is_queued_for_deletion():
		panel.self_modulate.a = 0
		await _hide_hover()

func _on_mouse_entered() -> void:
	grab_focus()

func _show_hover() -> void:
	if _hover_tween != null:
		_hover_tween.kill()
	var hover: Control = %Hover
	hover.visible = true
	_hover_tween = create_tween()
	_hover_tween.parallel().tween_property(hover, "modulate", Color.WHITE, .2)
	_hover_tween.parallel().tween_property(self, "scale", Vector2.ONE * 1.15, .2)
	_hover_tween.parallel().tween_property(%CompletedTick, "modulate", Color.TRANSPARENT, .2)

func _hide_hover() -> void:
	if _hover_tween != null:
		_hover_tween.kill()
	var hover: Control = %Hover
	_hover_tween = create_tween()
	_hover_tween.parallel().tween_property(hover, "modulate", Color.TRANSPARENT, .2)
	_hover_tween.parallel().tween_property(self, "scale", Vector2.ONE, .2)
	_hover_tween.parallel().tween_property(%CompletedTick, "modulate", Color.WHITE, .2)
	await _hover_tween.finished
	hover.visible = false
