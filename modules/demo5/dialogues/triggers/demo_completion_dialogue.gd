extends Node
## This node launches a dialogue when all the boars under the boar_list node have been fed.

const DEMO_SELECTOR_PATH := "res://modules/demo_selector/demo_selector.tscn"

@onready var level_completion_node: Node = $"../../LevelCompletionCheck"

@export var scene_root: Node3D
@export var dialogue: DialogueContainer

func _ready():
	level_completion_node.fed_all_boars.connect(launch_dialog)

func launch_dialog() -> void:
	DialogueSystem.load_dialogue(dialogue)
