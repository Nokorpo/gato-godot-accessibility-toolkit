extends Node

@export var dialogue: DialogueContainer
var _already_loaded: bool = false

func _on_gato_boar_selected(enclosure):
	if !_already_loaded:
		DialogueSystem.load_dialogue(dialogue)
		_already_loaded = true
