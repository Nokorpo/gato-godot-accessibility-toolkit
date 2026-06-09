## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
@tool
extends Button

@export var text_to_read: String = "Atacar"

func _ready() -> void:
	focus_entered.connect(_read_out_loud)

func _read_out_loud() -> void:
	if TextToSpeech.is_reading():
		await TextToSpeech.reading_stopped
	TextToSpeech.read(text_to_read)
