extends ColorRect

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
