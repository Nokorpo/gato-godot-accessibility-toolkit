class_name DemoPreview
extends Control

@export var data: DemoData

func _ready() -> void:
	%PreviewImage.texture = data.image
	%DemoTitle.text = data.title

func _on_pressed() -> void:
	print("click")

func _on_mouse_entered() -> void:
	var hover: Control = %Hover
	hover.modulate = Color.TRANSPARENT
	hover.visible = true
	create_tween().tween_property(hover, "modulate", Color.WHITE, .25)

func _on_mouse_exited() -> void:
	var hover: Control = %Hover
	var tween: Tween = create_tween()
	tween.tween_property(hover, "modulate", Color.TRANSPARENT, .25)
	await tween.finished
	hover.visible = false
