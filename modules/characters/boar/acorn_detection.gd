## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends Area3D


func get_acorn_in_range() -> Node3D:
	for body in self.get_overlapping_bodies():
		if body is Acorn:
			return body
	return null
