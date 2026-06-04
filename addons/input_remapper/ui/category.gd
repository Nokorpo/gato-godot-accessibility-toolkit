## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends VBoxContainer

@export var title: String = "Default Title"

func _ready() -> void:
	$Title.text = title
