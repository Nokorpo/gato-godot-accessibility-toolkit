extends Node

@export var dialogue: DialogueContainer

func _ready() -> void:
	DialogueSystem.load_dialogue(dialogue)
