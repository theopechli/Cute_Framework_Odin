package cute_framework

import "core:c"

Texture       :: struct { id: c.uint64_t }
Canvas        :: struct { id: c.uint64_t }
Mesh          :: struct { id: c.uint64_t }
Material      :: struct { id: c.uint64_t }
Shader        :: struct { id: c.uint64_t }
ComputeShader :: struct { id: c.uint64_t }
StorageBuffer :: struct { id: c.uint64_t }

PixelFormatOp :: enum c.int {
	NEAREST_FILTER,
	BILINEAR_FILTER,
	RENDER_TARGET,
	ALPHA_BLENDING,
	MSAA,
	DEPTH,
}

TextureUsageFlags :: distinct bit_set[TextureUsageBits; c.uint32_t]
TextureUsageBits :: enum c.uint32_t {
	SAMPLER_BIT,
	COLOR_TARGET_BIT,
	DEPTH_STENCIL_TARGET_BIT,
	GRAPHICS_STORAGE_READ_BIT,
	COMPUTE_STORAGE_READ_BIT,
	COMPUTE_STORAGE_WRITE_BIT,
}

Filter :: enum c.int {
	NEAREST,
	LINEAR,
}

MipFilter :: enum c.int {
	NEAREST,
	LINEAR,
}

WrapMode :: enum c.int {
	REPEAT,
	CLAMP_TO_EDGE,
	MIRRORED_REPEAT,
}

CompareFunction :: enum c.int {
	ALWAYS,
	NEVER,
	LESS_THAN,
	EQUAL,
	NOT_EQUAL,
	LESS_THAN_OR_EQUAL,
	GREATER_THAN,
	GREATER_THAN_OR_EQUAL,
}

TextureParams :: struct {
	pixel_format:     PixelFormat,
	usage:            TextureUsageFlags,
	filter:           Filter,
	wrap_u:           WrapMode,
	wrap_v:           WrapMode,
	mip_filter:       MipFilter,
	width:            c.int,
	height:           c.int,
	mip_count:        c.int,
	allocate_mipmaps: bool,
	mip_lod_bias:     c.float,
	max_anisotropy:   c.float,
	stream:           bool,
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	texture_defaults       :: proc(w: c.int, h: c.int) -> TextureParams ---
	make_texture           :: proc(texture_params: TextureParams) -> Texture ---
	destroy_texture        :: proc(texture: Texture) ---
	texture_update         :: proc(texture: Texture, data: rawptr, size: c.int) ---
	texture_handle         :: proc(texture: Texture) -> c.uint64_t ---
	texture_binding_handle :: proc(texture: Texture) -> c.uint64_t ---
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	shader_directory  :: proc(path: cstring) ---
	shader_on_changed :: proc(on_changed_fn: proc "odin" (path: cstring, udata: rawptr), udata: rawptr) ---
	make_shader       :: proc(vertex_path: cstring, fragment_path: cstring) -> Shader ---
	destroy_shader    :: proc(shader: Shader) ---
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	make_compute_shader    :: proc(path: cstring) -> ComputeShader ---
	destroy_compute_shader :: proc(shader: ComputeShader) ---
}

StorageBufferParams :: struct {
	size:              c.int,
	compute_readable:  bool,
	compute_writable:  bool,
	graphics_readable: bool,
	indirect_drawable: bool,
}

storage_buffer_defaults :: #force_inline proc "c" (size: c.int) -> StorageBufferParams {
	return {
		size              = size,
		compute_readable  = true,
		graphics_readable = true,
	}
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	make_storage_buffer    :: proc(params: StorageBufferParams) -> StorageBuffer ---
	update_storage_buffer  :: proc(buffer: StorageBuffer, data: rawptr, size: c.int) ---
	destroy_storage_buffer :: proc(buffer: StorageBuffer) ---
}

ComputeDispatch :: struct {
	rw_buffers:       ^StorageBuffer,
	rw_buffer_count:  c.int,
	rw_textures:      ^Texture,
	rw_texture_count: c.int,

	ro_buffers:       ^StorageBuffer,
	ro_buffer_count:  c.int,
	ro_textures:      ^Texture,
	ro_texture_count: c.int,

	group_count_x: c.int,
	group_count_y: c.int,
	group_count_z: c.int,
}

compute_dispatch_defaults :: #force_inline proc "c" (gx: c.int, gy: c.int, gz: c.int) -> ComputeDispatch {
	return {
		group_count_x = gx,
		group_count_y = gy,
		group_count_z = gz,
	}
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	dispatch_compute :: proc(shader: ComputeShader, material: Material, dispatch: ComputeDispatch) ---
}

SampleCount :: enum c.int {
	_1,
	_2,
	_4,
	_8,
}

MAX_CANVAS_TARGETS :: 8

CanvasParams :: struct {
	name: cstring,

	data: struct #raw_union {
		target: TextureParams,
		targets: [MAX_CANVAS_TARGETS]TextureParams,
	},

	target_count: c.int,

	attach_target: Texture,

	attach_layer: c.int,

	attach_mip: c.int,

	depth_stencil_enable: bool,

	depth_stencil_target: TextureParams,

	sample_count: SampleCount,
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	canvas_defaults                 :: proc(w: c.int, h: c.int) -> CanvasParams ---
	make_canvas                     :: proc(canvas_params: CanvasParams) -> Canvas ---
	destroy_canvas                  :: proc(canvas: Canvas) ---
	canvas_get_target               :: proc(canvas: Canvas) -> Texture ---
	canvas_get_depth_stencil_target :: proc(canvas: Canvas) -> Texture ---
	clear_canvas                    :: proc(canvas: Canvas) ---
}

VertexFormat :: enum c.int {
	INT,
	INT2,
	INT3,
	INT4,
	UINT,
	UINT2,
	UINT3,
	UINT4,
	FLOAT,
	FLOAT2,
	FLOAT3,
	FLOAT4,
	BYTE2,
	BYTE4,
	UBYTE2,
	UBYTE4,
	BYTE2_NORM,
	BYTE4_NORM,
	UBYTE2_NORM,
	UBYTE4_NORM,
	SHORT2,
	SHORT4,
	USHORT2,
	USHORT4,
	SHORT2_NORM,
	SHORT4_NORM,
	USHORT2_NORM,
	USHORT4_NORM,
	HALF2,
	HALF4,
}

VertexAttribute :: struct {
	name:         cstring,
	format:       VertexFormat,
	offset:       c.int,
	per_instance: bool,
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	make_mesh                 :: proc(vertex_buffer_size_in_bytes: i32, attributes: [^]VertexAttribute, attribute_count: c.int, vertex_stride: c.int) -> Mesh ---
	mesh_set_index_buffer     :: proc(mesh: Mesh, index_buffer_size_in_bytes: c.int, index_bit_count: c.int) ---
	mesh_set_instance_buffer  :: proc(mesh: Mesh, instance_buffer_size_in_bytes: c.int, instance_stride: c.int) ---
	destroy_mesh              :: proc(mesh: Mesh) ---
	mesh_update_vertex_data   :: proc(mesh: Mesh, data: rawptr, count: c.int) ---
	mesh_update_index_data    :: proc(mesh: Mesh, data: rawptr, count: c.int) ---
	mesh_update_instance_data :: proc(mesh: Mesh, data: rawptr, count: c.int) ---
}

CullMode :: enum c.int {
	NONE,
	FRONT,
	BACK,
}

StencilOp :: enum c.int {
	KEEP,
	ZERO,
	REPLACE,
	INCREMENT_CLAMP,
	DECREMENT_CLAMP,
	INVERT,
	INCREMENT_WRAP,
	DECREMENT_WRAP,
}

BlendOp :: enum c.int {
	ADD,
	SUBTRACT,
	REVERSE_SUBTRACT,
	MIN,
	MAX,
}

BlendFactor :: enum c.int {
	ZERO,
	ONE,
	SRC_COLOR,
	ONE_MINUS_SRC_COLOR,
	DST_COLOR,
	ONE_MINUS_DST_COLOR,
	SRC_ALPHA,
	ONE_MINUS_SRC_ALPHA,
	DST_ALPHA,
	ONE_MINUS_DST_ALPHA,
	CONSTANT_COLOR,
	ONE_MINUS_CONSTANT_COLOR,
	SRC_ALPHA_SATURATE,
}

PrimitiveType :: enum c.int {
	TRIANGLELIST,
	TRIANGLESTRIP,
	LINELIST,
	LINESTRIP,
}

StencilFunction :: struct {
	compare:       CompareFunction,
	fail_op:       StencilOp,
	depth_fail_op: StencilOp,
	pass_op:       StencilOp,
}

StencilParams :: struct {
	enabled:    bool,
	read_mask:  c.uint8_t,
	write_mask: c.uint8_t,
	reference:  c.uint8_t,
	front:      StencilFunction,
	back:       StencilFunction,
}

BlendState :: struct {
	enabled:                bool,
	pixel_format:           PixelFormat,
	write_R_enabled:        bool,
	write_G_enabled:        bool,
	write_B_enabled:        bool,
	write_A_enabled:        bool,
	rgb_op:                 BlendOp,
	rgb_src_blend_factor:   BlendFactor,
	rgb_dst_blend_factor:   BlendFactor,
	alpha_op:               BlendOp,
	alpha_src_blend_factor: BlendFactor,
	alpha_dst_blend_factor: BlendFactor,
}

RenderState :: struct {
	primitive_type: PrimitiveType,

	cull_mode: CullMode,

	data: struct #raw_union {
		blend: BlendState,
		blends: [MAX_CANVAS_TARGETS]BlendState,
	},

	blend_count: c.int,

	alpha_to_coverage: bool,

	depth_compare: CompareFunction,

	depth_write_enabled: bool,

	stencil: StencilParams,

	depth_bias_constant_factor: c.float,

	depth_bias_clamp: c.float,

	depth_bias_slope_factor: c.float,

	enable_depth_bias: bool,

	enable_depth_clip: bool,
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	render_state_defaults :: proc() -> RenderState ---
}

UniformType :: enum c.int {
	UNKNOWN = -1,
	FLOAT,
	FLOAT2,
	FLOAT3,
	FLOAT4,
	INT,
	INT2,
	INT4,
	MAT4,
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	make_material             :: proc() -> Material ---
	destroy_material          :: proc(material: Material) ---
	material_set_render_state :: proc(material: Material, render_state: RenderState) ---
	material_set_texture_fs   :: proc(material: Material, name: cstring, texture: Texture) ---
	material_set_uniform_vs   :: proc(material: Material, name: cstring, data: rawptr, type: UniformType, array_length: c.int) ---
	material_set_uniform_fs   :: proc(material: Material, name: cstring, data: rawptr, type: UniformType, array_length: c.int) ---
	material_set_texture_cs   :: proc(material: Material, name: cstring, texture: Texture) ---
	material_set_uniform_cs   :: proc(material: Material, name: cstring, data: rawptr, type: UniformType, array_length: c.int) ---
	clear_color               :: proc(red: c.float, green: c.float, blue: c.float, alpha: c.float) ---
	apply_canvas              :: proc(canvas: Canvas, clear: bool) ---
	apply_viewport            :: proc(x: c.int, y: c.int, w: c.int, h: c.int) ---
	apply_mesh                :: proc(mesh: Mesh) ---
	apply_shader              :: proc(shader: Shader, material: Material) ---
	draw_elements             :: proc() ---
	commit                    :: proc() ---
}
