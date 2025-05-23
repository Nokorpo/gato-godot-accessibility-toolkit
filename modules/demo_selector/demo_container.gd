extends GridContainer

var demo_list_resource: DemoList = load("res://modules/demo_selector/demo_list.tres")
var demo_preview: PackedScene = load("res://modules/demo_selector/demo_preview.tscn")

func _ready() -> void:
	for i in demo_list_resource.demos:
		add_child(demo_preview.instantiate())
