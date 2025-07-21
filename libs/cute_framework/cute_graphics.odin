package cute_framework

import "core:c"

Texture :: struct {
	id: u64,
}

Canvas :: struct {
	id: u64,
}

Mesh :: struct {
	id: u64,
}

Material :: struct {
	id: u64,
}

Shader :: struct {
	id: u64,
}

Pixel_Format :: enum c.int {
	Invalid = -1,
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

Pixel_Format_Op :: enum c.int {
	Nearest_Filter,
	Bilinear_Filter,
	Render_Target,
	Alpha_Blending,
	MSAA,
	Depth,
}

Texture_Usage_Flags :: distinct u32

Texture_Usages :: bit_set[Texture_Usage; c.int]
Texture_Usage :: enum c.int {
	Sampler,
	Color_Target,
	Depth_Stencil_Target,
	Graphics_Storage_Read,
	Compute_Storage_Read,
	Compute_Storage_Write,
}

Filter :: enum c.int {
	Nearest,
	Linear,
}

Mip_Filter :: enum c.int {
	Nearest,
	Linear,
}

Wrap_Mode :: enum c.int {
	Repeat,
	Clamp_To_Edge,
	Mirrored_Repeat,
}

Texture_Params :: struct {
	pixel_format:     Pixel_Format,
	usage:            Texture_Usage_Flags,
	filter:           Filter,
	wrap_u:           Wrap_Mode,
	wrap_v:           Wrap_Mode,
	mip_filter:       Mip_Filter,
	width:            c.int,
	height:           c.int,
	mip_count:        c.int,
	generate_mipmaps: bool,
	mip_lod_bias:     f32,
	max_anisotropy:   f32,
	stream:           bool,
}

Sample_Count :: enum c.int {
	_1,
	_2,
	_4,
	_8,
}

Canvas_Params :: struct {
	name:                 cstring,
	target:               Texture_Params,
	depth_stencil_enable: bool,
	depth_stencil_target: Texture_Params,
	sample_count:         Sample_Count,
}

Uniform_Type :: enum c.int {
	Unknown = -1,
	Float,
	Float2,
	Float3,
	Float4,
	Int,
	Int2,
	Int4,
	Mat4,
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	texture_defaults :: proc(w: c.int, h: c.int) -> Texture_Params ---
	make_texture :: proc(texture_params: Texture_Params) -> Texture ---
	destroy_texture :: proc(texture: Texture) ---
	texture_update :: proc(texture: Texture, data: rawptr, size: c.int) ---
	shader_directory :: proc(path: cstring) ---
	shader_on_changed :: proc(on_changed_fn: proc "odin" (path: cstring, udata: rawptr), udata: rawptr) ---
	make_shader :: proc(vertex_path: cstring, fragment_path: cstring) -> Shader ---
	canvas_defaults :: proc(w: c.int, h: c.int) -> Canvas_Params ---
	make_canvas :: proc(canvas_params: Canvas_Params) -> Canvas ---
	canvas_get_target :: proc(canvas: Canvas) -> Texture ---
	canvas_get_depth_stencil_target :: proc(canvas: Canvas) -> Texture ---
	clear_color :: proc(r: f32, g: f32, b: f32, a: f32) ---
	apply_canvas :: proc(canvas: Canvas, clear: bool) ---
}
