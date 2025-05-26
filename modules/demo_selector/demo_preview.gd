class_name DemoPreview
extends Control

@export var data: DemoData

func _ready() -> void:
	$PreviewImage.texture = data.image

func _on_pressed() -> void:
	print("click")

func _on_mouse_entered() -> void:
	$Hover.visible = true

func _on_mouse_exited() -> void:
	$Hover.visible = false
