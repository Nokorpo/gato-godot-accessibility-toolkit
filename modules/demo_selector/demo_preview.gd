class_name DemoPreview
extends TextureButton

@export var data: DemoData

func _ready() -> void:
	texture_normal = data.image

func _on_pressed() -> void:
	print("click")

func _on_mouse_entered() -> void:
	$Hover.visible = true

func _on_mouse_exited() -> void:
	$Hover.visible = false
