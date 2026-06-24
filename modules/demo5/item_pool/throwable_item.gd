## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
class_name ThrowableItem
extends Resource

@export var item_name : String
@export var item_scene: PackedScene
@export var spawn_point: Vector3
@export_enum("BLUE","RED","GREEN","YELLOW","BIN") var matching_color: String

static var shadow_texture: Texture = preload("res://modules/characters/shadow.svg")

var item_node: Node

func instantiate_item() -> Node:
	item_node = item_scene.instantiate()

	#var shadow := Decal.new()
	#shadow.texture_albedo = shadow_texture
	#shadow.size = Vector3(.20, 5., .20)
	#item_node.add_child(shadow)
	#shadow.position.y -= 2.5

	return item_node

func remove_item():
	item_node.queue_free()

func stop_anim_player():
	var anim_player : AnimationPlayer
	anim_player = item_node.find_child("AnimationPlayer", true)
	anim_player.stop()
