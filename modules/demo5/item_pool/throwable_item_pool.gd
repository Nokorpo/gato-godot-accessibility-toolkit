class_name ThrowableItemPool
extends Node

var _throwable_items: Array[ThrowableItem] = []
@export var accessible_throwable_items: Array[ThrowableItem] = []
@export var non_accessible_throwable_items: Array[ThrowableItem] = []

var current_item : ThrowableItem

func _ready():
	_throwable_items = non_accessible_throwable_items

func spawn_item() -> Node:
	current_item = _get_random_item()
	var spawned_item : Node = current_item.instantiate_item()
	add_child(spawned_item)
	spawned_item.position = current_item.spawn_point
	return spawned_item

func _get_random_item() -> ThrowableItem:
	var _random_item: ThrowableItem = _throwable_items.pick_random()
	return _random_item

func swap_items():
	_throwable_items = accessible_throwable_items
