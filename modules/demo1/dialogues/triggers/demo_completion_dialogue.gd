extends Node
## This node launches a dialogue when all the boars under the boar_list node have been fed.

const DEMO_SELECTOR_PATH := "res://modules/demo_selector/demo_selector.tscn"

@export var scene_root: Node3D
@export var boar_list: Node3D
@export var dialogue: DialogueContainer

var total_boars: int
var fed_boars: int = 0

func _ready() -> void:
	total_boars = boar_list.get_child_count()
	for boar: Boar in boar_list.get_children():
		boar.finished_feeding.connect(_another_one_bites_the_corn)

func _another_one_bites_the_corn() -> void:
	fed_boars += 1
	if fed_boars >= total_boars:
		launch_dialog()

func launch_dialog() -> void:
	DialogueSystem.load_dialogue(dialogue)
	await DialogueSystem.dialogue_finished
	SceneLoader.create_scene_loader(scene_root, DEMO_SELECTOR_PATH)

# Si quieres implementar tu propio Input Remapper, visita la documentación.
# Puedes encontrarla en el botón "Documentación" en el menú principal.
