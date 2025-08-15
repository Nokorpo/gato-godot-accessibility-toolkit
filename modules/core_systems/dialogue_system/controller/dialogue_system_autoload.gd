extends Node

signal dialogue_changed(message: DialogueMessage)

var dialogue: DialogueContainer
var current_message_index: int = 0

func _ready() -> void:
	pass # Replace with function body.

func load_dialogue(new_dialogue: DialogueContainer) -> DialogueMessage:
	dialogue = new_dialogue
	current_message_index = 0
	var current_message := dialogue.messages[current_message_index]
	dialogue_changed.emit(current_message)
	return current_message

func advance() -> DialogueMessage:
	current_message_index += 1
	var current_message := dialogue.messages[current_message_index]
	dialogue_changed.emit(current_message)
	return current_message
