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

Rect :: struct {
	x: c.int,
	y: c.int,
	w: c.int,
	h: c.int,
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

safe_norm :: #force_inline proc "contextless" (a: la.Vector2f32) -> la.Vector2f32 {
	sq := la.dot(a, a)
	return sq != 0.0 ? a / la.sqrt(sq) : {0.0, 0.0}
}

bezier :: #force_inline proc "contextless" (a: la.Vector2f32, c0: la.Vector2f32, b: la.Vector2f32, t: f32) -> la.Vector2f32 {
	return la.lerp(la.lerp(a, c0, t), la.lerp(c0, b, t), t)
}

sincos_f :: #force_inline proc "contextless" (radians: f32) -> Sin_Cos {
	return Sin_Cos {la.sin(radians), la.cos(radians)}
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

make_aabb_from_top_left :: #force_inline proc "contextless" (top_left: la.Vector2f32, w: f32, h: f32) -> AABB {
	return make_aabb(top_left + {0.0, -h}, top_left + {w, 0.0})
}

expand_aabb :: #force_inline proc "contextless" (aabb: AABB, v: la.Vector2f32) -> AABB {
	return make_aabb(aabb.lo - v, aabb.hi + v)
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
	aabb_to_aabb :: proc(a: AABB, b: AABB) -> bool ---
	aabb_to_capsule :: proc(a: AABB, b: Capsule) -> bool ---
	aabb_to_aabb_manifold :: proc(a: AABB, b: AABB) -> Manifold ---
	aabb_to_capsule_manifold :: proc(a: AABB, b: Capsule) -> Manifold ---
	toi :: proc(a: rawptr, shape_type_a: Shape_Type, transform_a: ^Transform, vel_a: la.Vector2f32, b: rawptr, shape_type_b: Shape_Type, transform_b: ^Transform, vel_b: la.Vector2f32, use_radius: c.int) -> TOI_Result ---
	collide :: proc(a: rawptr, ax: ^Transform, type_a: Shape_Type, b: rawptr, bx: ^Transform, type_b: Shape_Type, m: ^Manifold) ---
}
