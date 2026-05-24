extends Node

@export var dialogue: DialogueContainer

@onready var player: Node3D = $"../../Player"

func _ready() -> void:
	player.can_throw_item = false
	DialogueSystem.load_dialogue(dialogue)
	await DialogueSystem.dialogue_finished
	await get_tree().create_timer(0.3).timeout
	player.can_throw_item = true
