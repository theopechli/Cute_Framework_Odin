package cute_framework

import la "core:math/linalg"

Pixel :: struct #raw_union {
	colors: struct {
		r: u8,
		g: u8,
		b: u8,
		a: u8,
	},
	val: u32,
}

make_color_rgb :: #force_inline proc "contextless" (r, g, b: u8) -> la.Vector4f32 {
	return {
		f32(r) / 255.0,
		f32(g) / 255.0,
		f32(b) / 255.0,
		1.0,
	}
}

color_cyan :: #force_inline proc "contextless" () -> la.Vector4f32 {
	return make_color_rgb(68, 220, 235)
}
