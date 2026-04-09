class_name ThrowableItem
extends Resource

@export var item_name : String
@export var item_scene: PackedScene
@export var spawn_point: Vector3
@export var can_be_eaten : bool = false
@export_enum("blue","red","green","yellow") var matching_color: String

var item_node: Node

func instantiate_item() -> Node:
	item_node = item_scene.instantiate()
	return item_node

func remove_item():
	item_node.queue_free()
