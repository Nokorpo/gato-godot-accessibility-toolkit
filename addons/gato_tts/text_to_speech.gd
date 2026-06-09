## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends Node

## Emitted when a TTS reading starts. This is called an utterance. The parameter is the ID
## associated to this utterance.
signal reading_started(utterance_id: int)
## Emitted when a TTS reading stops. This is called an utterance. The parameter is the ID
## associated to this utterance.
signal reading_stopped(utterance_id: int)

const DEFAULT_VOICE: StringName = "default"

## Voices have different languages and accents for pronunciation. This String identifies what
## language has been selected and therefore what language the text will be read on.
var language: String = "en"
## Each language can have a number of voices: male, female, robotic, with different accents... Each
## of those voices has an ID. This String represents the selected voice.
var voice_id: String

func _ready() -> void:
	DisplayServer.tts_set_utterance_callback(
		DisplayServer.TTSUtteranceEvent.TTS_UTTERANCE_STARTED,
		_handle_utterance_start)
	DisplayServer.tts_set_utterance_callback(
		DisplayServer.TTSUtteranceEvent.TTS_UTTERANCE_ENDED,
		_handle_utterance_stop)
	DisplayServer.tts_set_utterance_callback(
		DisplayServer.TTSUtteranceEvent.TTS_UTTERANCE_CANCELED,
		_handle_utterance_stop)

## Update the language selected. A default voice will be chosen if no "voice_id"\
## is passed as the second parameter.
## [br]
## Notice that each OS has different voice IDs, so a voice ID for Windows might
## not work on Mac or Linux.
func set_language(country_code: StringName, new_voice_id: StringName = DEFAULT_VOICE) -> void:
	var voices = DisplayServer.tts_get_voices_for_language(country_code)
	var voice_index: int = 0
	if new_voice_id != DEFAULT_VOICE:
		voice_index = voices.find(new_voice_id)
	voice_id = voices[voice_index]

## Read a text with the previously selected language and voice.
func read(text: String) -> void:
	DisplayServer.tts_speak(text, voice_id)

## If a message is already being read, it will stop it.
func stop() -> void:
	DisplayServer.tts_stop()

## Returns true if a message is already being read. Otherwise, it returns false.
func is_reading() -> bool:
	return DisplayServer.tts_is_speaking()

func _handle_utterance_start(utterance_id: int):
	reading_started.emit(utterance_id)

func _handle_utterance_stop(utterance_id: int):
	reading_stopped.emit(utterance_id)
