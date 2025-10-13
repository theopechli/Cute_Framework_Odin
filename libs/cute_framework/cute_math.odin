package cute_framework

import "core:c"
import la "core:math/linalg"

V2 :: distinct [2]c.float

SinCos :: struct {
	s: c.float,
	c: c.float,
}

Transform :: struct {
	r: SinCos,
	p: V2,
}

Circle :: struct {
	p: V2,
	r: c.float,
}

Aabb :: struct {
	min: V2,
	max: V2,
}

Rect :: struct {
	x, y, w, h: c.int,
}

POLY_MAX_VERTS :: 8

Poly :: struct {
	count: c.int,
	verts: [POLY_MAX_VERTS]V2,
	norms: [POLY_MAX_VERTS]V2,
}

Capsule :: struct {
	a: V2,
	b: V2,
	r: c.float,
}

Manifold :: struct {
	count:          c.int,
	depths:         [2]c.float,
	contact_points: [2]V2,
	n:              V2,
}

safe_norm :: #force_inline proc "c" (a: V2) -> V2 { sq := la.dot(a, a); return sq != 0.0 ? a / la.sqrt(sq) : V2 { 0.0, 0.0 } }

bezier :: #force_inline proc "c" (a: V2, c0: V2, b: V2, t: c.float) -> V2 { return la.lerp(la.lerp(a, c0, t), la.lerp(c0, b, t), t) }

sincos_f :: #force_inline proc "c" (radians: c.float) -> SinCos { return SinCos { s = la.sin(radians), c = la.cos(radians) } }
sincos   :: #force_inline proc "c" () -> SinCos { return SinCos { s = 1.0, c = 0.0 } }

make_transform          :: #force_inline proc "c" () -> Transform { return Transform { p = V2 { 0.0, 0.0 }, r = sincos() } }
make_aabb               :: #force_inline proc "c" (min: V2, max: V2) -> Aabb { return Aabb { min = min, max = max } }
make_aabb_pos_w_h       :: #force_inline proc "c" (pos: V2, w: c.float, h: c.float) -> Aabb { he := V2 {w, h} * 0.5; return Aabb { min = pos - he, max = pos + he } }
make_aabb_from_top_left :: #force_inline proc "c" (top_left: V2, w: c.float, h: c.float) -> Aabb { return make_aabb(top_left + V2 { 0.0, -h }, top_left + V2 { w, 0.0 }) }
expand_aabb             :: #force_inline proc "c" (aabb: Aabb, v: V2) -> Aabb { return make_aabb(aabb.min - v, aabb.max + v) }

center       :: #force_inline proc "c" (bb: Aabb) -> V2 { return (bb.min + bb.max) * 0.5 }
top_left     :: #force_inline proc "c" (bb: Aabb) -> V2 { return V2 { bb.min.x, bb.max.y } }
top_right    :: #force_inline proc "c" (bb: Aabb) -> V2 { return V2 { bb.max.x, bb.max.y } }
bottom_left  :: #force_inline proc "c" (bb: Aabb) -> V2 { return V2 { bb.min.x, bb.min.y } }
bottom_right :: #force_inline proc "c" (bb: Aabb) -> V2 { return V2 { bb.max.x, bb.min.y } }

ShapeType :: enum c.int {
	NONE,
	CIRCLE,
	AABB,
	CAPSULE,
	POLY,
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	norms                       :: proc(verts: [^]V2, norms: [^]V2, count: c.int) ---
	aabb_to_aabb                :: proc(A: Aabb, B: Aabb) -> bool ---
	aabb_to_capsule             :: proc(A: Aabb, B: Capsule) -> bool ---
	circle_to_circle_manifold   :: proc(A: Circle, B: Circle) -> Manifold ---
	circle_to_capsule_manifold  :: proc(A: Circle, B: Capsule) -> Manifold ---
	aabb_to_aabb_manifold       :: proc(A: Aabb, B: Aabb) -> Manifold ---
	aabb_to_capsule_manifold    :: proc(A: Aabb, B: Capsule) -> Manifold ---
	capsule_to_capsule_manifold :: proc(A: Capsule, B: Capsule) -> Manifold ---
}

ToiResult :: struct {
	hit:        c.int,
	toi:        c.float,
	n:          V2,
	p:          V2,
	iterations: c.int,
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	toi     :: proc(A: rawptr, typeA: ShapeType, ax_ptr: ^Transform, vA: V2, B: rawptr, typeB: ShapeType, bx_ptr: ^Transform, vB: V2, use_radius: c.int) -> ToiResult ---
	collide :: proc(A: rawptr, ax: ^Transform, typeA: ShapeType, B: rawptr, bx: ^Transform, typeB: ShapeType, m: ^Manifold) ---
}
