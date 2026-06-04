## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
class_name GatoMesh
extends Node3D

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

enum Faces {
	NEUTRAL,
	HAPPY,
	SIDE_EYE,
	SURPRISED,
	WORRIED,
	WOW,
}

@export var face_images: Dictionary[Faces, Texture] = {}
@export var face_blinking_images: Dictionary[Faces, Texture] = {}
@export var minimum_blink_time: float
@export var maximum_blink_time: float
var current_face: Faces = Faces.NEUTRAL

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree

var custom_face_material: Material

var is_grounded: bool = false:
	set(value):
		is_grounded = update_animation_tree_condition("is_grounded", value)
var is_moving: bool = false:
	set(value):
		is_moving = update_animation_tree_condition("is_moving", value)

func _ready() -> void:
	_initialize_face_material()
	_start_blinking()

## We duplicate the default material to make it unique and to have an instance
## we can edit. The character's face is set as a texture for this material.
func _initialize_face_material() -> void:
	var face: MeshInstance3D = $rig/Skeleton3D/Face
	face.set_mesh(face.get_mesh().duplicate())
	custom_face_material = face.get_mesh().surface_get_material(0).duplicate()
	face.get_mesh().surface_set_material(0, custom_face_material)

func _start_blinking() -> void:
	$BlinkTimer.start()

func update_animation_tree_condition(condition_name: StringName, value: bool) -> bool:
	if animation_tree:
		animation_tree.set("parameters/conditions/%s" % condition_name, value)
	return value

func play_animation(animation: Animations) -> void:
	play_animation_name(_map_animation_enum_to_stringname(animation))

func play_animation_name(animation: StringName) -> void:
	animation_tree["parameters/playback"].travel(animation)

func _map_animation_enum_to_stringname(animation: Animations) -> StringName:
	return Animations.keys()[animation].to_lower()

func set_face(face: Faces) -> void:
	current_face = face
	var texture: Texture = face_images.get(face)
	custom_face_material.albedo_texture = texture

func set_face_name(face: StringName) -> void:
	if Faces.has(face.to_upper()):
		set_face(Faces.get(face.to_upper()))
	else:
		push_error("Error trying to set Gato's face for missing '%s' face." % face)

func blink() -> void:
	var blinking_texture: Texture = face_blinking_images.get(current_face)
	if blinking_texture != null:
		custom_face_material.albedo_texture = blinking_texture
		await get_tree().create_timer(0.1).timeout
		set_face(current_face)
