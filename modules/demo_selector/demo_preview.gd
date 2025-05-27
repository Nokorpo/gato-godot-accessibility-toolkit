class_name DemoPreview
extends Control

@export var data: DemoData
var _hover_tween: Tween

func _ready() -> void:
	%PreviewImage.texture = data.image
	%DemoTitle.text = data.title
	%Hover.modulate = Color.TRANSPARENT

func _on_pressed() -> void:
	print("click")

func _on_mouse_entered() -> void:
	if _hover_tween != null:
		_hover_tween.kill()
	var hover: Control = %Hover
	hover.visible = true
	_hover_tween = create_tween()
	_hover_tween.tween_property(hover, "modulate", Color.WHITE, .2)

func _on_mouse_exited() -> void:
	if _hover_tween != null:
		_hover_tween.kill()
	var hover: Control = %Hover
	_hover_tween = create_tween()
	_hover_tween.tween_property(hover, "modulate", Color.TRANSPARENT, .2)
	await _hover_tween.finished
	hover.visible = false
