## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
class_name BoarMesh
extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

enum Animations {
	IDLE,
	EAT,
	WALK,
}

func play_animation(animation: Animations) -> void:
	animation_player.play(_map_animation_enum_to_stringname(animation), 0.35)

func _map_animation_enum_to_stringname(animation: Animations) -> StringName:
	return Animations.keys()[animation].to_lower()
