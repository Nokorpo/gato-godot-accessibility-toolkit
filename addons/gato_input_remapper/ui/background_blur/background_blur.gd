## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
##
## This Control node is used to blur the background when showing a
## dialog on top of the screen.
extends ColorRect

## Show the blur progressively. If you need to wait for the
## animation to finish, this method returns the animation's `Tween`.
## You can use its `finished` signal to wait for completion.
func show_blur() -> Tween:
	mouse_filter = MOUSE_FILTER_STOP
	var tween := create_tween()
	tween.tween_property(self, "color", Color.WHITE, .25)
	tween.set_trans(Tween.TRANS_QUAD)
	return tween

## Hide the blur progressively. If you need to wait for the
## animation to finish, this method returns the animation's `Tween`.
## You can use its `finished` signal to wait for completion.
func hide_blur() -> Tween:
	mouse_filter = MOUSE_FILTER_IGNORE
	var tween := create_tween()
	tween.tween_property(self, "color", Color.TRANSPARENT, .25)
	tween.set_trans(Tween.TRANS_QUAD)
	return tween
