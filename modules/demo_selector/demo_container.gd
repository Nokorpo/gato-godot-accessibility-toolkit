extends GridContainer

@export var demo_list_resource: DemoList
var demo_preview: PackedScene = load("res://modules/demo_selector/demo_preview.tscn")

func _ready() -> void:
	for demo_data in demo_list_resource.demos:
		var new_preview = demo_preview.instantiate()
		new_preview.data = demo_data
		add_child(new_preview)
	get_child(0).grab_focus()
