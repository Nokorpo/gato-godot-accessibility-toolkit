extends Node

var color: String = "BIN"

@onready var player = %Player

var anim_player: AnimationPlayer
var is_open: bool = false

func _ready():
	anim_player = get_node("AnimationPlayer")
	player.connect("match_color", _receive_item)
	player.connect("focus_target", _focus)

func _receive_item(match_color):
	if match_color == color:
		anim_player.play("collect_item")

func _focus(match_color, has_focus):
	if has_focus and match_color == color:
		is_open = true
		anim_player.play("idle_selected")
	if !has_focus and is_open:
		anim_player.play("close_lid")
		is_open = false
