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

make_aabb_pos_w_h :: #force_inline proc(pos: la.Vector2f32, w: f32, h: f32) -> AABB {
	bb: AABB
	he := la.Vector2f32 {w, h} * 0.5
	bb.lo = pos - he
	bb.hi = pos + he
	return bb
}

center :: #force_inline proc(bb: AABB) -> la.Vector2f32 {
	return (bb.lo + bb.hi) * 0.5
}

top_left :: #force_inline proc(bb: AABB) -> la.Vector2f32 {
	return {bb.lo.x, bb.hi.y}
}

top_right :: #force_inline proc(bb: AABB) -> la.Vector2f32 {
	return {bb.hi.x, bb.hi.y}
}

bottom_left :: #force_inline proc(bb: AABB) -> la.Vector2f32 {
	return {bb.lo.x, bb.lo.y}
}

bottom_right :: #force_inline proc(bb: AABB) -> la.Vector2f32 {
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

sincos :: #force_inline proc() -> Sin_Cos {
	return Sin_Cos {1.0, 0.0}
}

make_transform :: #force_inline proc() -> Transform {
	return Transform {
		p = {0, 0},
		r = sincos(),
	}
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	norms :: proc(verts: ^la.Vector2f32, norms: ^la.Vector2f32, count: c.int) ---
}
