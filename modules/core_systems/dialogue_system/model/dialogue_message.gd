class_name DialogueMessage
extends Resource
## Resource that represents a message in the dialogue system. It allows setting text data like the
## message or character name, as well as the mesh that it's shown while the message is displayed.

## The text that will be shown in the main dialogue box.
@export var message: String
## The text on the character name tag, on top of the message.
@export var name: String
## If a character mesh should be shown, what animation to play while the message is displayed.
@export var animation_name: String
## If a character mesh should be shown, what face the character should have while the message is displayed.
@export var face: String
## If a character mesh should be shown, a reference to its scene so it can be loaded.
@export var mesh: PackedScene

func _init() -> void:
	pass
