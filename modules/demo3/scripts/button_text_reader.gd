@tool
extends Button

@export var text_to_read: String = "Atacar"

func _ready() -> void:
	focus_entered.connect(_read_out_loud)

func _read_out_loud() -> void:
	if TextToSpeech.is_reading():
		await TextToSpeech.reading_stopped
	TextToSpeech.read(text_to_read)
