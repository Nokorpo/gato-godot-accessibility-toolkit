## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
class_name Enclosure
extends Area3D

enum EnclosureType { A, B }

@export var enclosure_type: EnclosureType = EnclosureType.A

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body is EnclosureBoar and body.assigned_enclosure == enclosure_type:
		body.set_enclosure_as_reached()
