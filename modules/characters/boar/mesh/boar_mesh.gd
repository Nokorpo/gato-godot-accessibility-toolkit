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
