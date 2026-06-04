## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
class_name ThrowableItemPool
extends Node

var _throwable_items: Array[ThrowableItem] = []
@export var accessible_throwable_items: Array[ThrowableItem] = []
@export var non_accessible_throwable_items: Array[ThrowableItem] = []

var current_item : ThrowableItem

func _ready():
	_throwable_items = non_accessible_throwable_items

func spawn_item() -> Node:
	var _random_item: ThrowableItem = _throwable_items.pick_random()
	current_item = _random_item
	var spawned_item : Node = current_item.instantiate_item()
	add_child(spawned_item)
	spawned_item.position = current_item.spawn_point
	return spawned_item

func swap_items():
	_throwable_items = accessible_throwable_items
