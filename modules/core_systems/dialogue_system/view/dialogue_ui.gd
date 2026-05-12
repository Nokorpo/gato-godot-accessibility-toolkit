extends Control
## This node controls the dialogue system UI. It reacts to signals from dialogue_system_autoload.gd
## and orchestrates the UI to show the right message and avatar.

## Reference to the node containing the character name.
@onready var name_label: Label = $TextContainer/MarginContainer/MarginContainer/PanelContainer/MarginContainer/NameLabel
## Reference to the node containing the message text.
@onready var message_label: RichTextLabel = $TextContainer/MarginContainer/PanelContainer/MarginContainer/MessageLabel
## Reference to the character_avatar_ui.gd node that contains the character avatar.
@onready var character_avatar: Control = $AvatarContainer/CharacterContainer

var _is_active: bool = false

func _ready() -> void:
	_show_on_top_of_ui()
	DialogueSystem.ui = self
	DialogueSystem.dialogue_changed.connect(load_next_message)
	DialogueSystem.dialogue_started.connect(start)
	DialogueSystem.dialogue_finished.connect(stop)

## Ensures the UI tracks player input. Like, for advancing to the next message with a click.
func start() -> void:
	$NextMessageAudio.play()
	_is_active = true

## Stops tracking player input.
func stop() -> void:
	_is_active = false

## Updates the displayed message and avatar in the UI to the one passed as a parameter.
func load_next_message(message: DialogueMessage) -> void:
	set_message(message)
	set_avatar(message)

## Updates the displayed message and character name to the one passed as a parameter.
func set_message(message: DialogueMessage) -> void:
	name_label.text = message.name
	message_label.text = message.message

## Updates the displayed character avatar to the one passed as a parameter.
func set_avatar(message: DialogueMessage) -> void:
	if message.mesh != null and message.animation_name != null:
		character_avatar.set_avatar(message.mesh, message.animation_name, message.face)

## Ensures the UI is shown on top of the game world and game UI.
func _show_on_top_of_ui() -> void:
	var canvas := get_parent()
	if canvas != null and canvas is CanvasLayer:
		canvas.layer = 2

## Reacts to player input (like mouse click) to load the next message/close the UI.
func _advance_message() -> void:
	var next_message := DialogueSystem.advance()
	if next_message:
		$NextMessageAudio.play()
		set_message(next_message)
	else:
		$CloseDialogueAudio.play()
		hide()

func _input(event: InputEvent) -> void:
	if not _is_active:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			_advance_message()
	elif event.is_action("ui_accept") and event.is_pressed():
		_advance_message()
