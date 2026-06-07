## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends Node
## This is an autoload that handles interaction with the dialogue system. It tries to keep the
## interface clean by just providing methods to load a dialogue and advance to the next message.
##
## Nodes that need to react to it (like the UI) can do so via the dialogue started/finished and
## dialogue changed signals.

## Emitted every time the dialogue changes. This could mean the dialogue just started, it was
## advanced to the next message, or it finished. It includes the DialogueMessage object.
signal dialogue_changed(message: DialogueMessage)
## Emitted every time a new dialogue starts.
signal dialogue_started
## Emitted every time the current dialogue finishes.
signal dialogue_finished

## Reference to the dialogue UI.
var ui: Control
## Reference to the currently loaded dialogue.
var dialogue: DialogueContainer
## Keeps track of what message from the dialogue is currently being displayed.
var _current_message_index: int = 0

## Used to display a new dialogue. It makes sure to show the UI and load it if it doesn't exist.
## The parameter is the DialogueContainer with the dialogue to show.
## Returns the first message in the dialogue.
func load_dialogue(new_dialogue: DialogueContainer) -> DialogueMessage:
	if not ui:
		_load_ui()
	if not ui.visible:
		ui.show()
	dialogue = new_dialogue
	_current_message_index = 0
	var current_message := dialogue.messages[_current_message_index]
	dialogue_changed.emit(current_message)
	dialogue_started.emit()
	return current_message

func _load_ui() -> void:
	ui = load("res://modules/core_systems/dialogue_system/view/dialogue_ui.tscn").instantiate()
	var canvas := CanvasLayer.new()
	canvas.add_child(ui)
	add_child(canvas)

## Used to move to the next message when a dialogue is currently being played. If the dialogue
## doesn't have any more messages, it will close it.
## Returns the next message in the dialogue or null if the dialogue is over.
func advance() -> DialogueMessage:
	_current_message_index += 1
	if dialogue.messages.size() <= _current_message_index:
		dialogue_finished.emit()
		return null
	var current_message := dialogue.messages[_current_message_index]
	dialogue_changed.emit(current_message)
	return current_message
