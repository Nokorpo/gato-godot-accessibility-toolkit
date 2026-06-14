## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
extends ColorRect

func is_enabled() -> bool:
	return color.is_equal_approx(Color.WHITE)

func show_blur() -> Tween:
	mouse_filter = MOUSE_FILTER_STOP
	var tween := create_tween()
	tween.tween_property(self, "color", Color.WHITE, .25)
	tween.set_trans(Tween.TRANS_QUAD)
	return tween

func hide_blur() -> Tween:
	mouse_filter = MOUSE_FILTER_IGNORE
	var tween := create_tween()
	tween.tween_property(self, "color", Color.TRANSPARENT, .25)
	tween.set_trans(Tween.TRANS_QUAD)
	return tween
