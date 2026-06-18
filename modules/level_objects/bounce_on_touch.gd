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
var sfx: AudioStreamPlayer = null

func _ready() -> void:
	_make_grass_bounce_on_player_touch()
	if self.is_in_group("has_leafs"):
		sfx = get_tree().root.find_child("TreeShakeSFX", true, false)
	else:
		sfx = get_tree().root.find_child("GrassSFX", true, false)

func _make_grass_bounce_on_player_touch():
	# FIXME hack to make grass bounce when player touches it
	var area := Area3D.new()
	var collision_shape: CollisionShape3D = find_child("CollisionShape3D").duplicate()
	area.add_child(collision_shape)
	area.body_entered.connect(_on_body_entered)
	add_child(area)
	# grass has collisions disabled, therefore the static body isn't needed
	# trees do have collision enabled, so it won't be deleted
	var static_body: StaticBody3D = find_child("StaticBody3D")
	if static_body.get_collision_layer_value(1) == false:
		static_body.queue_free()

func _on_body_entered(body: Node3D) -> void:
	if body is Gato:
		react_to_player_collision()

func react_to_player_collision() -> void:
	if not is_instance_valid(tween) or not tween.is_running():
		if self.is_in_group("has_leafs"):
			emit_particles()
		sfx.play()
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
