class_name DemoPreview
extends Control

@export var data: DemoData

func _ready() -> void:
	$TextureRect.texture = data.image
