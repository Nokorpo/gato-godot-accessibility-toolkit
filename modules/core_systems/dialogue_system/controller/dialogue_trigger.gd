@tool
extends Node

@export var trigger_area: Area3D
@export var dialogue: DialogueContainer

func _ready() -> void:
	if trigger_area != null:
		trigger_area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body is Gato:
		DialogueSystem.load_dialogue(dialogue)

func _get_configuration_warnings() -> PackedStringArray:
	if trigger_area == null:
		return ["The 'trigger_area' variable is not set. DialogueTrigger expects an Area3D node as its 'trigger_area', please, set one up or it won't work. "]
	return []
