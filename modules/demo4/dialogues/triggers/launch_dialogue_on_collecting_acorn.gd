extends Node

@export var dialogue: Array[DialogueContainer]

func _ready():
	%GoldAcornManager.collected_goldacorn.connect(launch_dialog)

func launch_dialog(collected_acorns) -> void:
	DialogueSystem.load_dialogue(dialogue[collected_acorns-1])
