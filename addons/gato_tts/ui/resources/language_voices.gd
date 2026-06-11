## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
class_name GatoTTSLanguageVoices
extends Resource

enum Language { ES, EN }
enum GatoTTSPlatform { WINDOWS, MAC, LINUX }

@export var platform: GatoTTSPlatform
@export var curated_voices: Dictionary[Language, GatoTTSCuratedVoices]

func get_voices_for_language(language: StringName) -> GatoTTSCuratedVoices:
	var keys := Language.keys()
	for i: int in range(keys.size()):
		var key: String = keys[i]
		if key == language.to_upper():
			return curated_voices.values()[i]
	return null
