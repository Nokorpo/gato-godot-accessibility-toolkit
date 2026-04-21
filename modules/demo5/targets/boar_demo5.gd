extends Node

@export_enum("BLUE","RED","GREEN","YELLOW") var color: String

@onready var player : Node = %Player

var anim_player : AnimationPlayer

func _ready():
	player.connect("match_color", eat_acorn)
	player.connect("mismatch_color", refuse_acorn)
	anim_player = get_node("AnimationPlayer")
	anim_player.play("idle")

func eat_acorn(matching_color):
	if matching_color == color:
		anim_player.play("eat")
		anim_player.animation_set_next("eat", "idle")

func refuse_acorn(matching_color):
	#if matching_color == color:
		#anim_player.play("refuse")
		#anim_player.animation_set_next("refuset", "idle")
	pass
