## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends Control

## First node that will be selected when the menu grabs focus.
@export var first_item: Control

@onready var language_selector = %LanguageSelector
@onready var voice_selector = %VoiceSelector
@onready var speed_selector = %SpeedSelector

@onready var _accept_audio: AudioStreamPlayer = $AcceptAudioStreamPlayer

const DEFAULT_LANGUAGE: StringName = "ES"
const LANGUAGE_OPTIONS: Array[StringName] = ["ES", "EN"]
const VOICE_SPEED_OPTIONS: Array[StringName] = ["1.0", "1.5", "2.0", "0.5", "0.75"]

var _current_voices: Array[GatoTTSVoiceID] = []

func _ready() -> void:
	language_selector.options = LANGUAGE_OPTIONS
	speed_selector.options = VOICE_SPEED_OPTIONS
	language_selector.selection_changed.connect(_on_language_changed)
	voice_selector.selection_changed.connect(_on_voice_changed)
	speed_selector.selection_changed.connect(_on_speed_changed)
	_on_language_changed(DEFAULT_LANGUAGE)

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
