extends Node

@export var trigger_area: Area3D
@export var dialogue: DialogueContainer

func _ready() -> void:
	trigger_area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body is Gato:
		DialogueSystem.load_dialogue(dialogue)
