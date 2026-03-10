extends MarginContainer


func _on_mouse_entered() -> void:
	grab_focus()

func _on_mouse_exited() -> void:
	release_focus()

func _on_focus_entered() -> void:
	$Panel.show()

func _on_focus_exited() -> void:
	$Panel.hide()
