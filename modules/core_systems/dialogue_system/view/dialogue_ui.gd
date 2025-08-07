extends Control

@onready var name_label: Label = $MarginContainer/VBoxContainer/Panel/MarginContainer/NameLabel
@onready var message_label: RichTextLabel = $MarginContainer/VBoxContainer/PanelContainer/MarginContainer/MessageLabel
@onready var character_subviewport: SubViewport = $SubViewportContainer/SubViewport
@onready var character_holder: Node = $SubViewportContainer/SubViewport/Character

var character_mesh: Node3D
var character_animation_player: AnimationPlayer

func _ready() -> void:
	get_window().size_changed.connect(_resize_character_subviewport)
	_resize_character_subviewport()

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

func _resize_character_subviewport() -> void:
	var window_size := get_window().size
	character_subviewport.size = Vector2i(window_size.x/2, window_size.y)
