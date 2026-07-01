## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
##
## Button node used to test the currently selected voice with a default phrase.
## The default phrase can be updated by updating the
## `language_to_test_phrase_map` property.
extends Button

## A Dictionary that maps language strings (eg. "EN" for English, "ES"
## for Spanish...) to a phrase in that language that can be used to test
## the current selected voice.
@export var language_to_test_phrase_map: Dictionary[StringName, String] = {}


func _ready() -> void:
	pressed.connect(talk)

## Tells `GatoTextToSpeech` to read the phrase for the current language.
func talk() -> void:
	var phrase := language_to_test_phrase_map.get(GatoTextToSpeech.language.to_upper())
	GatoTextToSpeech.read(phrase)
