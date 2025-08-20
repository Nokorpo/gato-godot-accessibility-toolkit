extends Control

@onready var name_label: Label = $MarginContainer/VBoxContainer/Panel/MarginContainer/NameLabel
@onready var message_label: RichTextLabel = $MarginContainer/VBoxContainer/PanelContainer/MarginContainer/MessageLabel
@onready var character_avatar: Control = $CharacterContainer

var character_mesh: Node3D
var character_animation_player: AnimationPlayer
var _is_active: bool = false

func _ready() -> void:
	DialogueSystem.ui = self
	DialogueSystem.dialogue_changed.connect(load_next_message)
	DialogueSystem.dialogue_started.connect(start)
	DialogueSystem.dialogue_finished.connect(stop)

func start() -> void:
	$NextMessageAudio.play()
	_is_active = true

func stop() -> void:
	_is_active = false

func load_next_message(message: DialogueMessage) -> void:
	set_message(message)
	set_avatar(message)

func set_message(message: DialogueMessage) -> void:
	name_label.text = message.name
	message_label.text = message.message

func set_avatar(message: DialogueMessage) -> void:
	if message.mesh != null and message.animation_name != null:
		character_avatar.set_avatar(message.mesh, message.animation_name, message.face)

func _input(event: InputEvent) -> void:
	if not _is_active:
		return
	if event is InputEventMouseButton and event.is_pressed():
		var next_message := DialogueSystem.advance()
		if next_message:
			$NextMessageAudio.play()
			set_message(next_message)
		else:
			$CloseDialogueAudio.play()
			hide()
