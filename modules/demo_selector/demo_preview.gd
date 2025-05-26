class_name DemoPreview
extends TextureButton

@export var data: DemoData

func _ready() -> void:
	texture_normal = data.image
