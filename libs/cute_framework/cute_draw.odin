package cute_framework

import "core:c"

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	draw_sprite     :: proc(sprite: ^Sprite) ---
	draw_quad       :: proc(bb: Aabb, thickness: c.float, chubbiness: c.float) ---
	draw_quad_fill  :: proc(bb: Aabb, chubbiness: c.float) ---
	draw_quad_fill2 :: proc(p0: V2, p1: V2, p2: V2, p3: V2, chubbiness: c.float) ---
}

draw_box :: #force_inline proc "c" (bb: Aabb, thickness: c.float, chubbiness: c.float) { draw_quad(bb, thickness, chubbiness) }

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	draw_box_rounded             :: proc(bb: Aabb, thickness: c.float, radius: c.float) ---
	draw_box_rounded_fill        :: proc(bb: Aabb, radius: c.float) ---
	draw_circle                  :: proc(circle: Circle, thickness: c.float) ---
	draw_circle2                 :: proc(p: V2, r: c.float, thickness: c.float) ---
	draw_circle_fill             :: proc(circle: Circle) ---
	draw_circle_fill2            :: proc(p: V2, r: c.float) ---
	draw_capsule                 :: proc(capsule: Capsule, thickness: c.float) ---
	draw_line                    :: proc(p0: V2, p1: V2, thickness: c.float) ---
	draw_polyline                :: proc(points: [^]V2, count: c.int, thickness: c.float, loop: bool) ---
	draw_bezier_line             :: proc(a: V2, c0: V2, b: V2, iters: c.int, thickness: c.float) ---
	draw_push_layer              :: proc(layer: c.int) ---
	draw_pop_layer               :: proc() -> c.int ---
	draw_push_color              :: proc(c: Color) ---
	draw_pop_color               :: proc() -> Color ---
	draw_push_shape_aa           :: proc(aa: c.float) ---
	draw_pop_shape_aa            :: proc() -> c.float ---
	draw_push_vertex_attributes  :: proc(r: c.float, g: c.float, b: c.float, a: c.float) ---
	draw_push_vertex_attributes2 :: proc(attributes: Color) ---
	draw_pop_vertex_attributes   :: proc() -> Color ---
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	make_font                 :: proc(path: cstring, font_name: cstring) -> Result ---
	destroy_font              :: proc(font_name: cstring) ---
	push_font                 :: proc(font: cstring) ---
	pop_font                  :: proc() -> cstring ---
	push_font_size            :: proc(size: c.float) ---
	pop_font_size             :: proc() -> c.float ---
	push_font_blur            :: proc(blur: c.int) ---
	pop_font_blur             :: proc() -> c.int ---
	push_text_wrap_width      :: proc(width: c.float) ---
	pop_text_wrap_width       :: proc() -> c.float ---
	push_text_vertical_layout :: proc(layout_vertically: bool) ---
	pop_text_vertical_layout  :: proc() -> bool ---
	text_size                 :: proc(text: cstring, num_chars_to_draw: c.int = -1) -> V2 ---
	draw_text                 :: proc(text: cstring, position: V2, num_chars_to_draw: c.int = -1) ---
	push_text_id              :: proc(id: c.uint64_t) ---
	pop_text_id               :: proc() -> c.uint64_t ---
}

TextEffect :: struct {
	effect_name:          cstring,
	text_without_markups: cstring,
	on_begin:             c.bool,
	on_end:               c.bool,
	character:            c.int,
	index_into_string:    c.int,
	index_into_effect:    c.int,
	glyph_count:          c.int,
	elapsed:              c.float,
	center:               V2,
	q0,                   q1: V2,
	w,                    h:  c.int,
	color:                Color,
	colors:               [4]Color,
	use_colors:           c.bool,
	opacity:              c.float,
	xadvance:             c.float,
	visible:              c.bool,
	font_size:            c.float,
}


TextEffectFn :: #type proc "c" (fx: ^TextEffect) -> c.bool

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	text_effect_register   :: proc(name: cstring, fn: TextEffectFn) ---
	text_effect_get_number :: proc(fx: ^TextEffect, key: cstring, default_val: c.double) -> c.double ---
	text_effect_get_color  :: proc(fx: ^TextEffect, key: cstring, default_val: Color) -> Color ---
	text_effect_get_string :: proc(fx: ^TextEffect, key: cstring, default_val: cstring) -> cstring ---
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	text_without_markups    :: proc(text: cstring) -> cstring ---
	push_text_effect_active :: proc(effects_on: bool) ---
	pop_text_effect_active  :: proc() -> bool ---
	draw_push_viewport      :: proc(viewport: Rect) ---
	draw_pop_viewport       :: proc() -> Rect ---
	draw_push_scissor       :: proc(scissor: Rect) ---
	draw_pop_scissor        :: proc() -> Rect ---
	draw_push_render_state  :: proc(render_state: RenderState) ---
	draw_pop_render_state   :: proc() -> RenderState ---
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	make_draw_shader :: proc(path: cstring) -> Shader ---
	shader_reload    :: proc(shader: ^Shader) -> bool ---
	draw_push_shader :: proc(shader: Shader) ---
	draw_pop_shader  :: proc() -> Shader ---
}

DrawFilterMode :: enum {
	NEAREST,
	LINEAR,
	SMOOTH,
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	draw_push_filter       :: proc(mode: DrawFilterMode) ---
	draw_pop_filter        :: proc() -> DrawFilterMode ---
	draw_set_texture       :: proc(name: cstring, texture: Texture) ---
	draw_set_uniform       :: proc(name: cstring, data: rawptr, type: UniformType, array_length: c.int) ---
	draw_set_uniform_int   :: proc(name: cstring, val: c.int) ---
	draw_set_uniform_float :: proc(name: cstring, val: c.float) ---
	draw_translate         :: proc(w: c.float, h: c.float) ---
	draw_translate_v2      :: proc(position: V2) ---
	draw_scale             :: proc(w: c.float, h: c.float) ---
	draw_scale_v2          :: proc(scale: V2) ---
	draw_rotate            :: proc(radians: c.float) ---
	draw_TSR               :: proc(position: V2, scale: V2, radians: c.float) ---
	draw_TSR_absolute      :: proc(position: V2, scale: V2, radians: c.float) ---
	draw_push              :: proc() ---
	draw_pop               :: proc() ---
	draw_projection        :: proc(projection: M3x2) ---
	world_to_screen        :: proc(point: V2) -> V2 ---
	screen_to_world        :: proc(point: V2) -> V2 ---
	screen_bounds_to_world :: proc() -> Aabb ---
	draw_canvas            :: proc(canvas: Canvas, position: V2, scale: V2) ---
	render_to              :: proc(canvas: Canvas, clear: bool = false) ---
}
