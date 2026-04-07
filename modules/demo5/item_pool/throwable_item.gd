class_name ThrowableItem
extends Resource

@export var item_name : String
@export var item_scene: PackedScene

var item_node: Node

func instantiate_item() -> Node:
	item_node = item_scene.instantiate()
	return item_node

func get_animator() -> AnimationPlayer:
	var anim_player : AnimationPlayer
	anim_player = item_node.get_node("AnimationPlayer")
	return anim_player

func remove_item():
	item_node.queue_free()
