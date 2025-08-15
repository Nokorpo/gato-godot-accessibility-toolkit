extends Control

@onready var name_label: Label = $MarginContainer/VBoxContainer/Panel/MarginContainer/NameLabel
@onready var message_label: RichTextLabel = $MarginContainer/VBoxContainer/PanelContainer/MarginContainer/MessageLabel
@onready var character_avatar: Control = $CharacterContainer

var character_mesh: Node3D
var character_animation_player: AnimationPlayer


func set_message(message: DialogueMessage) -> void:
	name_label.text = message.name
	message_label.text = message.message

func set_avatar(message: DialogueMessage) -> void:
	character_avatar.set_avatar(message.mesh, message.animation_name)
