## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
class_name Acorn
extends RigidBody3D
## Simple acorn with no logic. The script only gives it a specific type so it can
## be detected by other scripts like the player.

@onready var raycast: RayCast3D = $RayCast3D
@onready var _original_parent: Node = get_parent()
var _is_on_platform: bool = false

var _running_tweens: Array[Tween] = []

func _ready() -> void:
	raycast.add_exception(self)

func animate_acorn_disappearance() -> Tween:
	# We use this vector instead of Vector3.ZERO because setting a scale of
	# zero is not supported by Jolt Physics and a warning is thrown.
	const APPROX_ZERO: Vector3 = Vector3(0.00001, 0.00001, 0.00001)
	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scale", APPROX_ZERO, .2)
	tween.tween_callback(_delete_when_safe)
	_running_tweens.append(tween)
	return tween

func _delete_when_safe() -> void:
	print(_running_tweens.size())
	queue_free()

func _physics_process(_delta: float) -> void:
	if not _is_on_platform and raycast.is_colliding():
		var collider := raycast.get_collider()
		if collider is Node3D and (collider as Node3D).is_in_group("moving_platform"):
			self.reparent(collider)
	elif _is_on_platform and not raycast.is_colliding():
		self.reparent(_original_parent)
