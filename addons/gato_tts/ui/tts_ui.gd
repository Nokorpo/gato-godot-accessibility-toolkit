## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
##
## This Control is a menu used to configure the voice used for the
## `GatoTextToSpeech` addon. It allows selecting language, voice and
## reading speed.
##
## Voices are selected manually to do some work for the developers,
## so if your language doesn't have a voice, feel free to open a PR!
extends Control

## First node that will be selected when the menu grabs focus.
@export var first_item: Control

## Reference to the language selector node.
@onready var language_selector = %LanguageSelector
## Reference to the voice selector node.
@onready var voice_selector = %VoiceSelector
## Reference to the reading speed selector node.
@onready var speed_selector = %SpeedSelector

@onready var _accept_audio: AudioStreamPlayer = $AcceptAudioStreamPlayer

## Default language used in the GatoTextToSpeech addon. This can be
## changed by calling the `GatoTTS.set_language` method.
const DEFAULT_LANGUAGE: StringName = "ES"
## List of supported languages in the `GatoTextToSpeech` addon.
const LANGUAGE_OPTIONS: Array[StringName] = ["ES", "EN"]
## List of pre-defined reading speeds in the `GatoTextToSpeech` addon.
const VOICE_SPEED_OPTIONS: Array[StringName] = ["1.0", "1.5", "2.0", "0.5", "0.75"]

var _current_voices: Array[GatoTTSVoiceID] = []

func _ready() -> void:
	language_selector.options = LANGUAGE_OPTIONS
	speed_selector.options = VOICE_SPEED_OPTIONS
	language_selector.selection_changed.connect(_on_language_changed)
	voice_selector.selection_changed.connect(_on_voice_changed)
	speed_selector.selection_changed.connect(_on_speed_changed)
	_on_language_changed(DEFAULT_LANGUAGE)

## Method used when the node grabs focus from a controller. It
## gives focus to the first element in the menu.
func grab_focus(hide_focus: bool = false) -> void:
	first_item.grab_focus(hide_focus)

func _on_language_changed(language: StringName) -> void:
	GatoTextToSpeech.set_language(language)
	# TODO update voices
	_current_voices = GatoTextToSpeech.get_voices_for_language(language)
	var voice_names: Array[StringName] = []
	for voice in _current_voices:
		voice_names.append(voice.name)
	%VoiceSelector.options = voice_names
	_accept_audio.play()

func _on_voice_changed(voice_name: StringName) -> void:
	var new_voice_index := _current_voices.find_custom(func(it:GatoTTSVoiceID): return it.name == voice_name)
	var new_voice := _current_voices[new_voice_index]
	GatoTextToSpeech.set_language(GatoTextToSpeech.language, new_voice.id)
	_accept_audio.play()

func _on_speed_changed(speed: StringName) -> void:
	GatoTextToSpeech.rate = float(speed)
	_accept_audio.play()
