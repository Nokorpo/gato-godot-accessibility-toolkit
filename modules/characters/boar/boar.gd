## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
class_name Boar
extends CharacterBody3D

@warning_ignore("unused_signal")
signal finished_feeding
@warning_ignore("unused_signal")
signal finished_growing

@onready var raycast: RayCast3D = $RayCast3D
@onready var _original_parent: Node = get_parent()
var _is_on_platform: bool = false

func _ready() -> void:
	raycast.add_exception(self)

func _physics_process(_delta: float) -> void:
	if not _is_on_platform and raycast.is_colliding():
		var collider := raycast.get_collider()
		if collider is Node3D and (collider as Node3D).is_in_group("moving_platform"):
			self.reparent(collider)
	elif _is_on_platform and not raycast.is_colliding():
		self.reparent(_original_parent)
