## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
class_name ThrowableItemPool
extends Node

var _throwable_items: Array[ThrowableItem] = []
@export var trash_throwable_items: Array[ThrowableItem] = []
@export var accessible_throwable_items: Array[ThrowableItem] = []
@export var non_accessible_throwable_items: Array[ThrowableItem] = []

var current_item : ThrowableItem
var _spawned_acorn_count: Array[int] = []
var _spawned_trash_count: Array[int] = []

func _ready():
	_throwable_items = non_accessible_throwable_items
	_spawned_acorn_count.resize(_throwable_items.size())
	_spawned_acorn_count.fill(0)
	_spawned_trash_count.resize(trash_throwable_items.size())
	_spawned_trash_count.fill(0)

func _inverse_count(count: int, max_count: int) -> int:
	return max_count - count

func _sum(accum, number):
	return accum + number

func _get_random_item() -> ThrowableItem:
	if randi() % 2 == 0:
		return _get_random_item_from_list(trash_throwable_items, _spawned_trash_count)
	else:
		return _get_random_item_from_list(_throwable_items, _spawned_acorn_count)

func _get_random_item_from_list(list: Array[ThrowableItem], count_list: Array[int]) -> ThrowableItem:
	var max_count: int = count_list.max()
	var weights: Array = count_list.map(_inverse_count.bind((max_count+1)*1.5))
	var max_weight: int = weights.reduce(_sum)
	var random: int = randi_range(0, max_weight)

	var index: int = -1
	for i in range(weights.size()):
		random -= weights[i]
		if random <= 0:
			index = i
			break

	count_list[index] += 1
	return list[index]

func spawn_item() -> Node:
	var _random_item: ThrowableItem = _get_random_item()
	current_item = _random_item
	var spawned_item : Node = current_item.instantiate_item()
	add_child(spawned_item)
	spawned_item.position = current_item.spawn_point
	return spawned_item

func swap_items():
	_throwable_items = accessible_throwable_items
