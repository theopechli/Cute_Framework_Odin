package cute_framework

import "core:c"
import la "core:math/linalg"

Sin_Cos :: la.Vector2f32

Transform :: struct {
	r: Sin_Cos,
	p: la.Vector2f32,
}

Circle :: struct {
	p: la.Vector2f32,
	r: f32,
}

AABB :: struct {
	lo: la.Vector2f32,
	hi: la.Vector2f32,
}

POLY_MAX_VERTS :: 8

Poly :: struct {
	count: i32,
	verts: [POLY_MAX_VERTS]la.Vector2f32,
	norms: [POLY_MAX_VERTS]la.Vector2f32,
}

Capsule :: struct {
	a: la.Vector2f32,
	b: la.Vector2f32,
	r: f32,
}

Manifold :: struct {
	count:          c.int,
	depths:         [2]f32,
	contact_points: [2]la.Vector2f32,
	n:              la.Vector2f32,
}

make_aabb :: #force_inline proc "contextless" (lo: la.Vector2f32, hi: la.Vector2f32) -> AABB {
	return AABB {
		lo = lo,
		hi = hi,
	}
}

make_aabb_pos_w_h :: #force_inline proc "contextless" (pos: la.Vector2f32, w: f32, h: f32) -> AABB {
	bb: AABB
	he := la.Vector2f32 {w, h} * 0.5
	bb.lo = pos - he
	bb.hi = pos + he
	return bb
}

center :: #force_inline proc "contextless" (bb: AABB) -> la.Vector2f32 {
	return (bb.lo + bb.hi) * 0.5
}

top_left :: #force_inline proc "contextless" (bb: AABB) -> la.Vector2f32 {
	return {bb.lo.x, bb.hi.y}
}

top_right :: #force_inline proc "contextless" (bb: AABB) -> la.Vector2f32 {
	return {bb.hi.x, bb.hi.y}
}

bottom_left :: #force_inline proc "contextless" (bb: AABB) -> la.Vector2f32 {
	return {bb.lo.x, bb.lo.y}
}

bottom_right :: #force_inline proc "contextless" (bb: AABB) -> la.Vector2f32 {
	return {bb.hi.x, bb.lo.y}
}

Shape_Types :: bit_set[Shape_Type; c.int]
Shape_Type :: enum c.int {
	None,
	Circle,
	AABB,
	Capsule,
	Poly,
}

sincos :: #force_inline proc "contextless" () -> Sin_Cos {
	return Sin_Cos {1.0, 0.0}
}

make_transform :: #force_inline proc "contextless" () -> Transform {
	return Transform {
		p = {0, 0},
		r = sincos(),
	}
}

TOI_Result :: struct {
	hit: c.int,
	toi: f32,
	n: la.Vector2f32,
	p: la.Vector2f32,
	iterations: c.int,
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	norms :: proc(verts: [^]la.Vector2f32, norms: [^]la.Vector2f32, count: c.int) ---
	aabb_to_aabb_manifold :: proc(a: AABB, b: AABB) -> Manifold ---
	aabb_to_capsule_manifold :: proc(a: AABB, b: Capsule) -> Manifold ---
	toi :: proc(a: rawptr, shape_type_a: Shape_Type, transform_a: ^Transform, vel_a: la.Vector2f32, b: rawptr, shape_type_b: Shape_Type, transform_b: ^Transform, vel_b: la.Vector2f32, use_radius: c.int) -> TOI_Result ---
	collide :: proc(a: rawptr, ax: ^Transform, type_a: Shape_Type, b: rawptr, bx: ^Transform, type_b: Shape_Type, m: ^Manifold) ---
}
