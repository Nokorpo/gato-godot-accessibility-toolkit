extends Node

@export var high_contrast_node: Node
@export var dialogue: DialogueContainer

func _ready():
	await DialogueSystem.dialogue_finished
	await get_tree().create_timer(.5).timeout
	high_contrast_node.show_ui()

	await high_contrast_node.enabled
	await get_tree().create_timer(2).timeout
	DialogueSystem.load_dialogue(dialogue)
	queue_free()
