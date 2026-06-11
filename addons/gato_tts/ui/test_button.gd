## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends Button

@export var language_to_test_phrase_map: Dictionary[StringName, String] = {}


func _ready() -> void:
	pressed.connect(talk)

func talk() -> void:
	var phrase := language_to_test_phrase_map.get(GatoTextToSpeech.language.to_upper())
	GatoTextToSpeech.read(phrase)
