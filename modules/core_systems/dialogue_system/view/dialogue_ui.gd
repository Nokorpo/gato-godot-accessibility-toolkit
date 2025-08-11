extends Control

@onready var name_label: Label = $MarginContainer/VBoxContainer/Panel/MarginContainer/NameLabel
@onready var message_label: RichTextLabel = $MarginContainer/VBoxContainer/PanelContainer/MarginContainer/MessageLabel
@onready var character_subviewport: SubViewport = $SubViewportContainer/SubViewport
@onready var character_holder: Node = $SubViewportContainer/SubViewport/Character

var character_mesh: Node3D
var character_animation_player: AnimationPlayer

func set_message(message: DialogueMessage) -> void:
	name_label.text = message.name
	message_label.text = message.message

func set_avatar(message: DialogueMessage) -> void:
	#TODO implement
	for child in character_holder.get_children():
		child.queue_free()
	var instance := message.mesh.instantiate()
	character_holder.add_child(instance)
	character_mesh = instance
