## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends Camera3D

@onready var horizontal_axis: Node3D = $"../.."
@onready var vertical_axis: Node3D = $".."

func get_horizontal_rotation() -> float:
	return horizontal_axis.rotation.y

func get_vertical_rotation() -> float:
	return vertical_axis.rotation.x
