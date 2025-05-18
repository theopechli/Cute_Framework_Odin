package cute_framework

import "core:c"
import la "core:math/linalg"

draw_box :: #force_inline proc(bb: AABB, thickness: f32, chubbiness: f32) {
	draw_quad(bb, thickness, chubbiness)
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	draw_sprite :: proc(sprite: ^Sprite) ---
	draw_quad :: proc(bb: AABB, thickness: f32, chubbiness: f32) ---
	draw_circle :: proc(circle: Circle, thickness: f32) ---
	draw_capsule :: proc(capsule: Capsule, thickness: f32) ---
	draw_line :: proc(p0: la.Vector2f32, p1: la.Vector2f32, thickness: f32) ---
	draw_polyline :: proc(points: [^]la.Vector2f32, count: c.int, thickness: f32, loop: bool) ---
	draw_push_layer :: proc(layer: c.int) ---
	draw_pop_layer :: proc() -> c.int ---
	draw_push_color :: proc(c: la.Vector4f32) ---
	draw_pop_color :: proc() -> la.Vector4f32 ---
	draw_scale :: proc(w: f32, h: f32) ---
	draw_push :: proc() ---
	draw_pop :: proc() ---
}
