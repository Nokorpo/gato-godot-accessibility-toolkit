extends Control

@onready var name_label: Label = $MarginContainer/VBoxContainer/Panel/MarginContainer/NameLabel
@onready var message_label: RichTextLabel = $MarginContainer/VBoxContainer/PanelContainer/MarginContainer/MessageLabel
@onready var character_avatar: Control = $CharacterContainer

var character_mesh: Node3D
var character_animation_player: AnimationPlayer


func _ready() -> void:
	DialogueSystem.ui = self
	DialogueSystem.dialogue_changed.connect(load_next_message)
	DialogueSystem.dialogue_finished.connect(close_dialogue)

func load_next_message(message: DialogueMessage) -> void:
	set_message(message)
	set_avatar(message)
	$NextMessageAudio.play()

func close_dialogue() -> void:
	$CloseDialogueAudio.play()

func set_message(message: DialogueMessage) -> void:
	name_label.text = message.name
	message_label.text = message.message

func set_avatar(message: DialogueMessage) -> void:
	if message.mesh != null and message.animation_name != null:
		character_avatar.set_avatar(message.mesh, message.animation_name)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		var next_message := DialogueSystem.advance()
		if next_message:
			set_message(next_message)
		else:
			hide()
