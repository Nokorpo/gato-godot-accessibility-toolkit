@tool
extends Node

@export var animation_name: String

func _ready() -> void:
	var animations: AnimationPlayer = get_parent().find_child("AnimationPlayer")
	animations.play(animation_name)
