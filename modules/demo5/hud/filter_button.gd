## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
class_name FilterButton
extends TextureButton

signal pressed_button(filter: Filter)

@export var filter: Filter
@export var filter_icon: CompressedTexture2D

@onready var texture_rect: TextureRect = %Icon

var selected_border: TextureRect
var unselected_border: TextureRect

func _ready():
	texture_rect.texture = filter_icon

func _on_toggled(toggled_on):
	if toggled_on == true:
		pressed_button.emit(filter)
		var tween: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		tween.tween_property(self, "scale:x", 1.2, 0.15)
		tween.parallel().tween_property(self, "scale:y", 1.1, 0.25)
		tween.tween_property(self, "scale:x", 1, 0.35)
		tween.parallel().tween_property(self, "scale:y", 1, 0.2)

func disable():
	disabled = true
	texture_rect.modulate = Color(0.341, 0.341, 0.341)

func enable():
	disabled = false
	texture_rect.modulate = Color(1.0, 1.0, 1.0)
