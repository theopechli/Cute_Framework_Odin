package cute_framework

import "core:c"

Texture  :: struct { id: c.uint64_t }
Canvas   :: struct { id: c.uint64_t }
Mesh     :: struct { id: c.uint64_t }
Material :: struct { id: c.uint64_t }
Shader   :: struct { id: c.uint64_t }

PixelFormat :: enum c.int {
	INVALID = -1,
	A8_UNORM,
	R8_UNORM,
	R8G8_UNORM,
	R8G8B8A8_UNORM,
	R16_UNORM,
	R16G16_UNORM,
	R16G16B16A16_UNORM,
	R10G10B10A2_UNORM,
	B5G6R5_UNORM,
	B5G5R5A1_UNORM,
	B4G4R4A4_UNORM,
	B8G8R8A8_UNORM,
	BC1_RGBA_UNORM,
	BC2_RGBA_UNORM,
	BC3_RGBA_UNORM,
	BC4_R_UNORM,
	BC5_RG_UNORM,
	BC7_RGBA_UNORM,
	BC6H_RGB_FLOAT,
	BC6H_RGB_UFLOAT,
	R8_SNORM,
	R8G8_SNORM,
	R8G8B8A8_SNORM,
	R16_SNORM,
	R16G16_SNORM,
	R16G16B16A16_SNORM,
	R16_FLOAT,
	R16G16_FLOAT,
	R16G16B16A16_FLOAT,
	R32_FLOAT,
	R32G32_FLOAT,
	R32G32B32A32_FLOAT,
	R11G11B10_UFLOAT,
	R8_UINT,
	R8G8_UINT,
	R8G8B8A8_UINT,
	R16_UINT,
	R16G16_UINT,
	R16G16B16A16_UINT,
	R8_INT,
	R8G8_INT,
	R8G8B8A8_INT,
	R16_INT,
	R16G16_INT,
	R16G16B16A16_INT,
	R8G8B8A8_UNORM_SRGB,
	B8G8R8A8_UNORM_SRGB,
	BC1_RGBA_UNORM_SRGB,
	BC2_RGBA_UNORM_SRGB,
	BC3_RGBA_UNORM_SRGB,
	BC7_RGBA_UNORM_SRGB,
	D16_UNORM,
	D24_UNORM,
	D32_FLOAT,
	D24_UNORM_S8_UINT,
	D32_FLOAT_S8_UINT,
}

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
	generate_mipmaps: bool,
	mip_lod_bias:     c.float,
	max_anisotropy:   c.float,
	stream:           bool,
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	texture_defaults :: proc(w: c.int, h: c.int) -> TextureParams ---
	make_texture     :: proc(texture_params: TextureParams) -> Texture ---
	destroy_texture  :: proc(texture: Texture) ---
	texture_update   :: proc(texture: Texture, data: rawptr, size: c.int) ---
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	shader_directory  :: proc(path: cstring) ---
	shader_on_changed :: proc(on_changed_fn: proc "odin" (path: cstring, udata: rawptr), udata: rawptr) ---
	make_shader       :: proc(vertex_path: cstring, fragment_path: cstring) -> Shader ---
	destroy_shader    :: proc(shader: Shader) ---
}

SampleCount :: enum c.int {
	_1,
	_2,
	_4,
	_8,
}

CanvasParams :: struct {
	name:                 cstring,
	target:               TextureParams,
	depth_stencil_enable: bool,
	depth_stencil_target: TextureParams,
	sample_count:         SampleCount,
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	canvas_defaults                 :: proc(w: c.int, h: c.int) -> CanvasParams ---
	make_canvas                     :: proc(canvas_params: CanvasParams) -> Canvas ---
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
	mesh_set_instance_buffer  :: proc(mesh: Mesh, instance_buffer_size_in_bytes: c.int, instance_stride: c.int) ---
	destroy_mesh              :: proc(mesh: Mesh) ---
	mesh_update_vertex_data   :: proc(mesh: Mesh, data: rawptr, count: c.int) ---
	mesh_update_instance_data :: proc(mesh: Mesh, data: rawptr, count: c.int) ---
}

CullMode :: enum c.int {
	NONE,
	FRONT,
	BACK,
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
	primitive_type:             PrimitiveType,
	cull_mode:                  CullMode,
	blend:                      BlendState,
	depth_compare:              CompareFunction,
	depth_write_enabled:        bool,
	stencil:                    StencilParams,
	depth_bias_constant_factor: c.float,
	depth_bias_clamp:           c.float,
	depth_bias_slope_factor:    c.float,
	enable_depth_bias:          bool,
	enable_depth_clip:          bool,
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
	material_set_uniform_vs   :: proc(material: Material, name: cstring, data: rawptr, type: UniformType, array_length: c.int) ---
	material_set_uniform_fs   :: proc(material: Material, name: cstring, data: rawptr, type: UniformType, array_length: c.int) ---
	clear_color               :: proc(red: c.float, green: c.float, blue: c.float, alpha: c.float) ---
	apply_canvas              :: proc(canvas: Canvas, clear: bool) ---
	apply_viewport            :: proc(x: c.int, y: c.int, w: c.int, h: c.int) ---
	apply_mesh                :: proc(mesh: Mesh) ---
	apply_shader              :: proc(shader: Shader, material: Material) ---
	draw_elements             :: proc() ---
	commit                    :: proc() ---
}
