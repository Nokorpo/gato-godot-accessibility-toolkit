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
class_name GatoTTSCuratedVoices
extends Resource

@export var voice_id_list: Array[GatoTTSVoiceID] = []
