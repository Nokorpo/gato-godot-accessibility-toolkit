extends Node

@export var documentation_link: String

func _on_pressed():
	OS.shell_open(documentation_link)
