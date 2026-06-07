## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends Node3D

@export var dialogue01: Node
@export var dialogue02: Node

func _ready() -> void:
	for child: Node in get_children():
		_disable(child)

	await get_parent().ready
	_disable(dialogue01)

	_enable(dialogue02)
	await dialogue02.finished
	_disable(dialogue02)

func _enable(node: Node) -> void:
	node.process_mode = Node.PROCESS_MODE_INHERIT

func _disable(node: Node) -> void:
	node.process_mode = Node.PROCESS_MODE_DISABLED
