class_name ThrowableItem
extends Resource

@export var item_name : String
@export var item_scene: PackedScene
@export var spawn_point: Vector3
@export_enum("BLUE","RED","GREEN","YELLOW","BIN") var matching_color: String

var item_node: Node

func instantiate_item() -> Node:
	item_node = item_scene.instantiate()
	return item_node

func remove_item():
	item_node.queue_free()

func stop_anim_player():
	var anim_player : AnimationPlayer
	anim_player = item_node.find_child("AnimationPlayer", true)
	anim_player.stop()
