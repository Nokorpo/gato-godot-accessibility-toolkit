# GATO: Text-to-Speech

This plugin is a plug-and-play tool for games to have text-to-speech options. It is based on Godot's
TTS, but it provides a simpler API and a UI that can be used while playing the game to configure the
voice that reads the text.

### How it works

Godot's solution is already really good, so this is mostly a wrapper for Godot's
[DisplayWindow text-to-speech functions](https://docs.godotengine.org/en/stable/tutorials/audio/text_to_speech.html).
It centralizes TTS configuration and usage in a single Autoload script with
dedicated signals and methods.

### Usage example

First you need to initialize it by providing a language. It will take a default
voice from that language so you don't have to choose.

```gdscript
func _ready() -> void:
	GatoTextToSpeech.set_language("es") # "es" for Spanish voices
```

Then you can use it like this. This will read the button's text ("Action") out loud.

```
# button.gd

var button_text: String = "Action"

func _on_focus_grabbed() -> void:
	GatoTextToSpeech.read(button_text)
```

-----------

This plugin is part of [GATO (Godot Accessibility Toolkit)](https://github.com/Nokorpo/gato-godot-accessibility-toolkit).
