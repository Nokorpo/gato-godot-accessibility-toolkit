class_name GatoMesh
extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func play_animation(animation_name: StringName) -> void:
	animation_player.play(animation_name)
