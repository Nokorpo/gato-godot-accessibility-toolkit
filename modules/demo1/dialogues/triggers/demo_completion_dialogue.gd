## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends Node
## This node launches a dialogue when all the boars under the boar_list node have been fed.

const DEMO_SELECTOR_PATH := "res://modules/demo_selector/demo_selector.tscn"

@export var scene_root: Node3D
@export var dialogue: DialogueContainer

func launch_dialog() -> void:
	DialogueSystem.load_dialogue(dialogue)

# Si quieres implementar tu propio Input Remapper, visita la documentación.
# Puedes encontrarla en el botón "Documentación" en el menú principal.
