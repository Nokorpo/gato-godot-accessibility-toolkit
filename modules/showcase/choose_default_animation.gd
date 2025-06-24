@tool
extends Node

@export var animation_name: String:
	set(value):
		animation_name = value
		_update_animation.call_deferred()

func _ready() -> void:
	_update_animation.call_deferred()

func _update_animation():
	var animations: AnimationPlayer = get_parent().find_child("AnimationPlayer")
	animations.play(animation_name)
