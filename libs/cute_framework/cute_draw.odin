package cute_framework

import "core:c"
import la "core:math/linalg"

draw_box :: #force_inline proc "contextless" (bb: AABB, thickness: f32, chubbiness: f32) {
	draw_quad(bb, thickness, chubbiness)
}

Text_Effect :: struct {
	effect_name: cstring,
	on_begin: bool,
	on_end: bool,
	character: c.int,
	index_into_string: c.int,
	index_into_effect: c.int,
	glyph_count: c.int,
	elapsed: f32,
	center: la.Vector2f32,
	q0: la.Vector2f32,
	q1: la.Vector2f32,
	w: c.int,
	h: c.int,
	color: la.Vector4f32,
	opacity: f32,
	xadvance: f32,
	visible: bool,
	font_size: f32,
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	draw_sprite :: proc(sprite: ^Sprite) ---
	draw_quad :: proc(bb: AABB, thickness: f32, chubbiness: f32) ---
	draw_quad_fill :: proc(bb: AABB, chubbiness: f32) ---
	draw_box_rounded :: proc(bb: AABB, thickness: f32, radius: f32) ---
	draw_box_rounded_fill :: proc(bb: AABB, radius: f32) ---
	draw_circle :: proc(circle: Circle, thickness: f32) ---
	draw_capsule :: proc(capsule: Capsule, thickness: f32) ---
	draw_line :: proc(p0: la.Vector2f32, p1: la.Vector2f32, thickness: f32) ---
	draw_polyline :: proc(points: [^]la.Vector2f32, count: c.int, thickness: f32, loop: bool) ---
	draw_bezier_line :: proc(a: la.Vector2f32, c0: la.Vector2f32, b: la.Vector2f32, iters: c.int, thickness: f32) ---
	draw_push_layer :: proc(layer: c.int) ---
	draw_pop_layer :: proc() -> c.int ---
	draw_push_color :: proc(c: la.Vector4f32) ---
	draw_pop_color :: proc() -> la.Vector4f32 ---
	make_font :: proc(path: cstring, font_name: cstring) -> Result ---
	destroy_font :: proc(font_name: cstring) ---
	push_font :: proc(font: cstring) ---
	pop_font :: proc() -> cstring ---
	push_font_size :: proc(size: f32) ---
	pop_font_size :: proc() -> f32 ---
	push_font_blur :: proc(blur: c.int) ---
	pop_font_blur :: proc() -> c.int ---
	push_text_wrap_width :: proc(width: f32) ---
	pop_text_wrap_width :: proc() -> f32 ---
	push_text_vertical_layout :: proc(layout_vertically: bool) ---
	pop_text_vertical_layout :: proc() -> bool ---
	text_size :: proc(text: cstring, num_chars_to_draw: c.int = -1) -> la.Vector2f32 ---
	draw_text :: proc(text: cstring, position: la.Vector2f32, num_chars_to_draw: c.int = -1) ---
	push_text_effect_active :: proc(effects_on: bool) ---
	pop_text_effect_active :: proc() -> bool ---
	draw_push_scissor :: proc(scissor: Rect) ---
	draw_pop_scissor :: proc() -> Rect ---
	draw_push_render_state :: proc(render_state: Render_State) ---
	draw_pop_render_state :: proc() -> Render_State ---
	make_draw_shader :: proc(path: cstring) -> Shader ---
	draw_push_shader :: proc(shader: Shader) ---
	draw_pop_shader :: proc() -> Shader ---
	draw_set_texture :: proc(name: cstring, texture: Texture) ---
	draw_set_uniform :: proc(name: cstring, data: rawptr, type: Uniform_Type, array_length: c.int) ---
	draw_set_uniform_int :: proc(name: cstring, val: c.int) ---
	draw_set_uniform_float :: proc(name: cstring, val: f32) ---
	draw_translate :: proc(w: f32, h: f32) ---
	draw_scale :: proc(w: f32, h: f32) ---
	draw_push :: proc() ---
	draw_pop :: proc() ---
	render_to :: proc(canvas: Canvas, clear: bool = false) ---
	world_to_screen :: proc(point: la.Vector2f32) -> la.Vector2f32 ---
	screen_to_world :: proc(point: la.Vector2f32) -> la.Vector2f32 ---
	draw_canvas :: proc(canvas: Canvas, position: la.Vector2f32, scale: la.Vector2f32) ---
}
