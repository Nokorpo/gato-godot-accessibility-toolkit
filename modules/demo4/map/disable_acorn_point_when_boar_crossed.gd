## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends Area3D

@export var acorn_landing_point: Node3D

func _ready() -> void:
	body_entered.connect(_disable_landing_point_if_boar)

func _disable_landing_point_if_boar(body: PhysicsBody3D) -> void:
	if body is Boar and is_instance_valid(acorn_landing_point):
		acorn_landing_point.queue_free()
		queue_free()
