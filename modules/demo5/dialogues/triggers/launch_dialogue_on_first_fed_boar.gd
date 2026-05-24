extends Node

@export var dialogue: DialogueContainer

@onready var level_completion_node: Node = $"../../LevelCompletionCheck"
@onready var filter_menu: Node = $"../../FiltersMenu"
@onready var player: Node3D = $"../../Player"

var already_shown: bool

func _ready():
	level_completion_node.update_hud_count.connect(check_fed_boars_count)

func check_fed_boars_count():
	if level_completion_node.fed_boars > 0 and !already_shown:
		player.can_throw_item = false
		launch_dialog()
		already_shown = true

func launch_dialog() -> void:
	DialogueSystem.load_dialogue(dialogue)
	await DialogueSystem.dialogue_finished
	await get_tree().create_timer(0.3).timeout
	filter_menu.are_filters_blocked = false
	filter_menu.select_filter(Filter.new(Filter.FilterType.PROTANOPIA))
	filter_menu.are_filters_blocked = true
	player.can_throw_item = true
