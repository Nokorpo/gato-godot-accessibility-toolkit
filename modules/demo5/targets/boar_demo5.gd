extends Node3D

@export_enum("BLUE","RED","GREEN","YELLOW") var color: String

@onready var player: Node = %Player
@onready var outline_material: StandardMaterial3D = load("res://modules/demo5/targets/boars/selection_outline.tres")

var body_material: StandardMaterial3D 
var anim_player: AnimationPlayer
var heart_particles: GPUParticles3D
var fed: bool = false

func _ready():
	player.connect("focused_target", focus_feedback)
	player.connect("matched_color", eat_acorn)
	player.connect("mismatched_color", refuse_acorn)
	anim_player = get_node("AnimationPlayer")
	heart_particles = get_node("HeartParticles")
	body_material = find_child("Body", true, false).get_active_material(0)
	anim_player.play("idle")

func eat_acorn(matching_color):
	if matching_color == color:
		anim_player.animation_set_next("eat", "idle")
		anim_player.play("eat")
		if !fed:
			await get_tree().create_timer(0.3).timeout
			scale *= 1.2
			fed = true
			heart_particles.emitting = true

func refuse_acorn(matching_color):
	if matching_color == color:
		anim_player.animation_set_next("refuse", "idle")
		anim_player.play("refuse")
		if fed:
			fed = false
			heart_particles.emitting = false
			await get_tree().create_timer(0.3).timeout
			scale = Vector3(1,1,1)

func focus_feedback(matching_color, focused):
	if matching_color == color and focused:
		scale *= 1.3
		body_material.next_pass = outline_material
	elif fed:
		scale = Vector3(1.2,1.2,1.2)
	else:
		scale = Vector3(1,1,1)
	if !focused:
		body_material.next_pass = null
