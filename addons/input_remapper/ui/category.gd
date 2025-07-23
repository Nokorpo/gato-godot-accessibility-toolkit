extends VBoxContainer

@export var title: String = "Default Title"

func _ready() -> void:
	$Title.text = title
