extends Node

@export var boars_node: Node3D
@export var dialogue: DialogueContainer

func _ready():
	for boar:EnclosureBoar in boars_node.get_children():
		boar.connect("finished_growing", _activate_dialogue)

func _activate_dialogue():
	DialogueSystem.load_dialogue(dialogue)
