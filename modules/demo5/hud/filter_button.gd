class_name FilterButton
extends Button

signal pressed_button(filter: Filter)

@export var filter: Filter
@export var filter_icon: TextureRect

var selected_border: TextureRect
var unselected_border: TextureRect

func _on_focus_entered():
	pass

func _on_focus_exited():
	pass # Replace with function body.

func _on_toggled(toggled_on):
	if toggled_on == true:
		pressed_button.emit(filter)
	print(toggled_on)

func disable():
	#gray out
	pass

func enable():
	pass
