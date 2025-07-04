class_name GatoMesh
extends Node3D

var is_grounded: bool = false:
	set(value):
		is_grounded = update_animation_tree_condition("is_grounded", value)
var is_moving: bool = false:
	set(value):
		is_moving = update_animation_tree_condition("is_moving", value)

func update_animation_tree_condition(condition_name: StringName, value: bool) -> bool:
	if animation_tree:
		animation_tree.set("parameters/conditions/%s" % condition_name, value)
	return value

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree

enum Animations {
	IDLE,
	JUMP,
	JUMP_AIR,
	JUMP_FALL,
	JUMP_LAND,
	TALK_HAPPY,
	TALK_NEUTRAL,
	TALK_SIDE_EYE,
	TALK_SURPRISED,
	TALK_WORRIED,
	THROW,
	WALK,
}

func play_animation(animation: Animations) -> void:
	animation_tree["parameters/playback"].travel(_map_animation_enum_to_stringname(animation))

func _map_animation_enum_to_stringname(animation: Animations) -> StringName:
	return Animations.keys()[animation].to_lower()
