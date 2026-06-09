## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends Node

signal reading_started(utterance_id: int)
signal reading_stopped(utterance_id: int)

var language: String = "en"
var voice_id: String

func set_language(country_code: StringName) -> void:
	var voices = DisplayServer.tts_get_voices_for_language(country_code)
	voice_id = voices[0]

	DisplayServer.tts_set_utterance_callback(
		DisplayServer.TTSUtteranceEvent.TTS_UTTERANCE_STARTED,
		_handle_utterance_start)
	DisplayServer.tts_set_utterance_callback(
		DisplayServer.TTSUtteranceEvent.TTS_UTTERANCE_ENDED,
		_handle_utterance_stop)
	DisplayServer.tts_set_utterance_callback(
		DisplayServer.TTSUtteranceEvent.TTS_UTTERANCE_CANCELED,
		_handle_utterance_stop)

func read(text: String) -> void:
	DisplayServer.tts_speak(text, voice_id)

func stop() -> void:
	DisplayServer.tts_stop()

func is_reading() -> bool:
	return DisplayServer.tts_is_speaking()

func _handle_utterance_start(utterance_id: int):
	reading_started.emit(utterance_id)

func _handle_utterance_stop(utterance_id: int):
	reading_stopped.emit(utterance_id)
