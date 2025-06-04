package cute_framework

import "core:c"
import la "core:math/linalg"

draw_box :: #force_inline proc "contextless" (bb: AABB, thickness: f32, chubbiness: f32) {
	draw_quad(bb, thickness, chubbiness)
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	draw_sprite :: proc(sprite: ^Sprite) ---
	draw_quad :: proc(bb: AABB, thickness: f32, chubbiness: f32) ---
	draw_quad_fill :: proc(bb: AABB, chubbiness: f32) ---
	draw_circle :: proc(circle: Circle, thickness: f32) ---
	draw_capsule :: proc(capsule: Capsule, thickness: f32) ---
	draw_line :: proc(p0: la.Vector2f32, p1: la.Vector2f32, thickness: f32) ---
	draw_polyline :: proc(points: [^]la.Vector2f32, count: c.int, thickness: f32, loop: bool) ---
	draw_bezier_line :: proc(a: la.Vector2f32, c0: la.Vector2f32, b: la.Vector2f32, iters: c.int, thickness: f32) ---
	draw_push_layer :: proc(layer: c.int) ---
	draw_pop_layer :: proc() -> c.int ---
	draw_push_color :: proc(c: la.Vector4f32) ---
	draw_pop_color :: proc() -> la.Vector4f32 ---
	make_draw_shader :: proc(path: cstring) -> Shader ---
	draw_push_shader :: proc(shader: Shader) ---
	draw_pop_shader :: proc() -> Shader ---
	draw_set_texture :: proc(name: cstring, texture: Texture) ---
	draw_set_uniform :: proc(name: cstring, data: rawptr, type: Uniform_Type, array_length: c.int) ---
	draw_set_uniform_int :: proc(name: cstring, val: c.int) ---
	draw_set_uniform_float :: proc(name: cstring, val: f32) ---
	draw_scale :: proc(w: f32, h: f32) ---
	draw_push :: proc() ---
	draw_pop :: proc() ---
	render_to :: proc(canvas: Canvas, clear: bool = false) ---
	screen_to_world :: proc(point: la.Vector2f32) -> la.Vector2f32 ---
}
