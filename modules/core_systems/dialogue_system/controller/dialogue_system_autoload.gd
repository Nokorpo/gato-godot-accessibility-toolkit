extends Node

signal dialogue_changed(message: DialogueMessage)
signal dialogue_finished

var ui: Control
var dialogue: DialogueContainer
var current_message_index: int = 0

func load_dialogue(new_dialogue: DialogueContainer) -> DialogueMessage:
	if not ui:
		_load_ui()
	if not ui.visible:
		ui.show()
	dialogue = new_dialogue
	current_message_index = 0
	var current_message := dialogue.messages[current_message_index]
	dialogue_changed.emit(current_message)
	return current_message

func _load_ui() -> void:
	ui = load("res://modules/core_systems/dialogue_system/view/dialogue_ui.tscn").instantiate()
	var canvas := CanvasLayer.new()
	canvas.add_child(ui)
	add_child(canvas)

func advance() -> DialogueMessage:
	current_message_index += 1
	if dialogue.messages.size() <= current_message_index:
		dialogue_finished.emit()
		return null
	var current_message := dialogue.messages[current_message_index]
	dialogue_changed.emit(current_message)
	return current_message
