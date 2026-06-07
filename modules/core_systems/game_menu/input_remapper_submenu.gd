extends CanvasLayer

func get_button_text() -> String:
	return "Controles"

func grab_focus() -> void:
	$InputRemapperUi.grab_focus()
