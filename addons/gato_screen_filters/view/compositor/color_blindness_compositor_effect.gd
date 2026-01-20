@tool
class_name ColorBlindnessShader
extends CompositorEffect

@export_enum ( "None:0", "Protanopia:1", "Protanomaly:2", "Deuteranopia:3", "Deuteranomaly:4", "Tritanopia:5", "Tritanomaly:6", "Achromatopsia:7", "Achromatomaly:8" )
var color_blindness_type: int = 0:
	set(type):
		if type < 0 or type > 8:
			push_error("Tried to assign a non-existing color blindness type \"%d\"." % type)
			return
		color_blindness_type = type
		var data := _generate_buffer_data()
		if not buffer:
			# create
			buffer = rd.uniform_buffer_create(data.size(), data)
		else:
			# update
			var update_err := rd.buffer_update(buffer, 0, data.size(), data)
			if update_err != 0:
				print_debug("Error while updating buffer: ", update_err)

var shader_path := "uid://bpdrjfs6h53ql":
	set(path):
		shader_path = path
		# rebuild shader
		#var shader_file : RDShaderFile = load(path)
		#var shader_spirv : RDShaderSPIRV = shader_file.get_spirv()
		#var shader : RID = rd.shader_create_from_spirv(shader_spirv)
var rd: RenderingDevice
var shader: RID
var buffer: RID
var pipeline: RID

func _init() -> void:
	effect_callback_type = EFFECT_CALLBACK_TYPE_POST_TRANSPARENT
	rd = RenderingServer.get_rendering_device()
	RenderingServer.call_on_render_thread(_initialize_compute)

func _generate_buffer_data() -> PackedByteArray:
	return PackedInt32Array([int(color_blindness_type), 0, 0, 0]).to_byte_array()

# System notifications, we want to react on the notification that
# alerts us we are about to be destroyed.
func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		if shader.is_valid():
			# Freeing our shader will also free any dependents such as the pipeline!
			rd.free_rid(shader)


#region Code in this region runs on the rendering thread.
# Compile our shader at initialization.
func _initialize_compute() -> void:
	rd = RenderingServer.get_rendering_device()
	if not rd:
		return

	# Compile our shader.
	var shader_file := load(shader_path)
	var shader_spirv: RDShaderSPIRV = shader_file.get_spirv()

	shader = rd.shader_create_from_spirv(shader_spirv)
	if shader.is_valid():
		pipeline = rd.compute_pipeline_create(shader)

# Called by the rendering thread every frame.
func _render_callback(p_effect_callback_type: EffectCallbackType, p_render_data: RenderData) -> void:
	if rd and p_effect_callback_type == EFFECT_CALLBACK_TYPE_POST_TRANSPARENT and pipeline.is_valid():
		# Get our render scene buffers object, this gives us access to our render buffers.
		# Note that implementation differs per renderer hence the need for the cast.
		var render_scene_buffers := p_render_data.get_render_scene_buffers()
		if render_scene_buffers:
			# Get our render size, this is the 3D render resolution!
			var size: Vector2i = render_scene_buffers.get_internal_size()
			if size.x == 0 and size.y == 0:
				return

			# We can use a compute shader here.
			@warning_ignore("integer_division")
			var x_groups := (size.x - 1) / 8 + 1
			@warning_ignore("integer_division")
			var y_groups := (size.y - 1) / 8 + 1
			var z_groups := 1

			# Create push constant.
			# Must be aligned to 16 bytes and be in the same order as defined in the shader.
			var push_constant := _generate_buffer_data()

			# Loop through views just in case we're doing stereo rendering. No extra cost if this is mono.
			var view_count: int = render_scene_buffers.get_view_count()
			for view in view_count:
				# Get the RID for our color image, we will be reading from and writing to it.
				var input_image: RID = render_scene_buffers.get_color_layer(view)

				# Create a uniform set, this will be cached, the cache will be cleared if our viewports configuration is changed.
				var uniform := RDUniform.new()
				uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
				uniform.binding = 0
				uniform.add_id(input_image)
				var uniform_set := UniformSetCacheRD.get_cache(shader, 0, [uniform])

				# Run our compute shader.
				var compute_list := rd.compute_list_begin()
				rd.compute_list_bind_compute_pipeline(compute_list, pipeline)
				rd.compute_list_bind_uniform_set(compute_list, uniform_set, 0)
				rd.compute_list_set_push_constant(compute_list, push_constant, push_constant.size())
				rd.compute_list_dispatch(compute_list, x_groups, y_groups, z_groups)
				rd.compute_list_end()
#endregion
