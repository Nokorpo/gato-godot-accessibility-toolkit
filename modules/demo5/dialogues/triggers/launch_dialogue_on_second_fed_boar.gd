extends Node

@export var dialogue: DialogueContainer

@onready var level_completion_node: Node = $"../../LevelCompletionCheck"
@onready var filter_menu: Node = $"../../FiltersMenu"
@onready var player: Node3D = $"../../Player"

var already_shown: bool

func _ready():
	level_completion_node.update_hud_count.connect(check_fed_boars_count)

func check_fed_boars_count():
	if level_completion_node.fed_boars > 1 and !already_shown:
		launch_dialog()
		already_shown = true

func launch_dialog() -> void:
	DialogueSystem.load_dialogue(dialogue)
	await DialogueSystem.dialogue_finished
	filter_menu.unblock_filters()
	await get_tree().create_timer(0.3).timeout
	player.can_throw_item = true
