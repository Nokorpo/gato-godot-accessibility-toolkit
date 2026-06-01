extends GridContainer

@export var demo_list_resource: DemoList
var demo_preview: PackedScene = load("res://modules/demo_selector/demo_preview.tscn")

@onready var demo_selector: Node = $"../.."

func _ready() -> void:
	if FeatureFlags.get_flag("show_demo_2"):
		demo_list_resource.demos[1] = load("res://modules/demo_selector/assets/demo2_preview.tres")
	for demo_data in demo_list_resource.demos:
		var new_preview: DemoPreview = demo_preview.instantiate()
		new_preview.data = demo_data
		new_preview.demo_pressed.connect(load_demo)
		add_child(new_preview)
	get_child(0).grab_focus()

func load_demo(data: DemoData) -> SceneLoader:
	if not data.scene:
		push_error("Could not open the demo '%s'. The scene value is empty." % data.title)
		return
	return SceneLoader.create_scene_loader(demo_selector, data.scene.resource_path)
