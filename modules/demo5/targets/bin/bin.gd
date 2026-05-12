extends Node3D

var color: String = "BIN"

@onready var player = %Player
@onready var confetti_effect: GPUParticles3D = $ConfettiEffect
@onready var rejection_effect: GPUParticles3D = $PoofEffect
@onready var outline_material: StandardMaterial3D = load("res://modules/demo5/targets/boars/selection_outline.tres")

var bin_meshes: Array = [MeshInstance3D]
var anim_player: AnimationPlayer
var is_open: bool = false

func _ready():
	anim_player = get_node("AnimationPlayer")
	player.connect("matched_color", _receive_item)
	player.connect("mismatched_color", _refuse_item)
	player.connect("focused_target", _focus)
	bin_meshes = find_children("", "MeshInstance3D", true, false)

func _receive_item(match_color):
	if match_color == color:
		anim_player.play("collect_item")
		is_open = true
		confetti_effect.emitting = true

func _focus(match_color, has_focus):
	if has_focus and match_color == color:
		is_open = true
		anim_player.play("idle_selected")
		scale *= 1.2
		_add_outline_material()
	if !has_focus and is_open:
		anim_player.play("close_lid")
		is_open = false
		scale = Vector3(1,1,1)
		_remove_outline_material()

func _add_outline_material():
	for mesh in bin_meshes:
		mesh.get_active_material(0).next_pass = outline_material

func _remove_outline_material():
	for mesh in bin_meshes:
		mesh.get_active_material(0).next_pass = null

func _refuse_item(match_color):
	if match_color == color:
		rejection_effect.emitting = true
