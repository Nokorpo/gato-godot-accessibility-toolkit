## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
##
## This class is a Resource used to configure the default voices for
## each OS and language. We try to provide defaults so that developers
## using this addon don't have to waddle through lists of dozens or
## hundreds of voices to select defaults for their game.
##
## The list of curated voices can be found in `res://addons/gato_tts/ui/resources/`
## under the names `windows.tres`, `linux.tres`.
class_name GatoTTSLanguageVoices
extends Resource

## Enum representing the list of supported languages in this addon.
enum Language { ES, EN }
## Enum representing the list of supported platforms in this addon.
enum GatoTTSPlatform { WINDOWS, MAC, LINUX }

## The platform for this configuration.
@export var platform: GatoTTSPlatform
## A dictionary that maps a `Language` with a `GatoTTSCuratedVoices`
## object containing a list of voices for that `Language`.
@export var curated_voices: Dictionary[Language, GatoTTSCuratedVoices]

## Returns a `GatoTTSCuratedVoices` object containing the pre-configured
## voices for the current OS and parameter `language`.
func get_voices_for_language(language: StringName) -> GatoTTSCuratedVoices:
	var keys := Language.keys()
	for i: int in range(keys.size()):
		var key: String = keys[i]
		if key == language.to_upper():
			return curated_voices.values()[i]
	return null
