extends CanvasLayer


func exit_game() -> void:
	get_tree().quit()

func hide_confirmation_screen() -> void:
	visible = false
