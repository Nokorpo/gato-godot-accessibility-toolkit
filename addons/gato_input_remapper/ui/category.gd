## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
##
## A simple Control used as a separator for `GatoControlScheme` categories. It includes a title.
extends VBoxContainer

## The title this node will show.
@export var title: String = "Default Title"

func _ready() -> void:
	$Title.text = title
