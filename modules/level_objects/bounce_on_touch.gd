## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
class_name BounceOnTouch
extends Node3D
## An example of how to react to player collision. This is used to make props bob back and forth
## when touched by the player

const FORCE := 0.2
var tween: Tween

var leaf_particles = load("res://modules/demo1/map/vfx/leaf_particles.tscn")

func react_to_player_collision() -> void:
	if not is_instance_valid(tween) or not tween.is_running():
		if self.is_in_group("has_leafs"):
			emit_particles()
		tween = create_tween().set_trans(Tween.TRANS_SINE)

		tween.tween_property(self, "rotation", Vector3( 1, 0, 1) * FORCE  , .2)
		tween.tween_property(self, "rotation", Vector3(-1, 0,-1) * FORCE/2, .2)
		tween.tween_property(self, "rotation", Vector3( 1, 0, 1) * FORCE/4, .2)
		tween.tween_property(self, "rotation", Vector3(-1, 0,-1) * FORCE/8, .2)
		tween.tween_property(self, "rotation", Vector3( 0, 0, 0), .2)

		tween.tween_callback(tween.kill)

func emit_particles() -> void:
	var leaf_instance = leaf_particles.instantiate()
	add_child(leaf_instance)
	leaf_instance.position = Vector3(0,1,0)
	leaf_instance.rotate_x(deg_to_rad(-90))
