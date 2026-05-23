extends Node3D

const NORMAL_SCALE = Vector3.ONE
const FED_SCALE = Vector3.ONE * 1.2
const FOCUS_SCALE = Vector3.ONE * 1.3

signal finished_growing
signal decreased

@export_enum("BLUE","RED","GREEN","YELLOW") var color: String

@onready var outline_material: StandardMaterial3D = load("res://modules/demo5/targets/boars/selection_outline.tres")

var body_material: StandardMaterial3D 
var anim_player: AnimationPlayer
var heart_particles: GPUParticles3D
var eating_particles: CPUParticles3D
var refusing_particles: GPUParticles3D
var fed: bool = false

func _ready():
	var player = get_tree().get_first_node_in_group("player")
	player.connect("focused_target", focus_feedback)
	player.connect("matched_color", eat_acorn)
	player.connect("mismatched_color", refuse_acorn)
	if has_node("AnimationPlayer") == true:
		anim_player = get_node("AnimationPlayer")
	else:
		anim_player = get_node("Boar/AnimationPlayer")
	heart_particles = get_node("HeartParticles")
	eating_particles = get_node("EatingParticles")
	refusing_particles = get_node("PoofEffect")
	body_material = find_child("Body", true, false).get_active_material(0)
	anim_player.play("idle")

func eat_acorn(matching_color):
	if matching_color == color:
		anim_player.animation_set_next("eat", "idle")
		anim_player.play("eat")
		eating_particles.emitting = true
		if !fed:
			await get_tree().create_timer(0.3).timeout
			scale = FED_SCALE
			fed = true
			heart_particles.emitting = true
			finished_growing.emit()

func refuse_acorn(matching_color):
	if matching_color == color:
		anim_player.animation_set_next("refuse", "idle")
		anim_player.play("refuse")
		refusing_particles.emitting = true
		if fed:
			fed = false
			heart_particles.emitting = false
			await get_tree().create_timer(0.3).timeout
			scale = NORMAL_SCALE
			decreased.emit()

func focus_feedback(matching_color, focused):
	if matching_color == color and focused:
		scale = FOCUS_SCALE
		body_material.next_pass = outline_material
	elif fed:
		scale = FED_SCALE
	else:
		scale = NORMAL_SCALE
	if !focused:
		body_material.next_pass = null
