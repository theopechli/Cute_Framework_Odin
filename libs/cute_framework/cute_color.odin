package cute_framework

import la "core:math/linalg"

Color :: la.Vector4f32

Pixel :: struct #raw_union {
	colors: struct {
		r: u8,
		g: u8,
		b: u8,
		a: u8,
	},
	val: u32,
}

make_color_rgb_f :: #force_inline proc "contextless" (r, g, b: f32) -> Color {
	return {r, g, b, 1.0}
}

make_color_rgba_f :: #force_inline proc "contextless" (r, g, b, a: f32) -> Color {
	return {r, g, b, a}
}

make_color_rgb :: #force_inline proc "contextless" (r, g, b: u8) -> Color {
	return {
		f32(r) / 255.0,
		f32(g) / 255.0,
		f32(b) / 255.0,
		1.0,
	}
}

make_pixel_rgb :: #force_inline proc "contextless" (r, g, b: u8) -> Pixel {
	p: Pixel
	p.colors.r = r
	p.colors.g = g
	p.colors.b = b
	p.colors.a = 255
	return p
}

color_invisible :: #force_inline proc "contextless" () -> Color {
	return make_color_rgba_f(0.0, 0.0, 0.0, 0.0)
}

color_clear :: #force_inline proc "contextless" () -> Color {
	return make_color_rgba_f(0.0, 0.0, 0.0, 0.0)
}

color_black :: #force_inline proc "contextless" () -> Color {
	return make_color_rgb_f(0.0, 0.0, 0.0)
}

color_white :: #force_inline proc "contextless" () -> Color {
	return make_color_rgb_f(1.0, 1.0, 1.0)
}

color_red :: #force_inline proc "contextless" () -> Color {
	return make_color_rgb_f(1.0, 0.0, 0.0)
}

color_grey :: #force_inline proc "contextless" () -> Color {
	return make_color_rgb_f(0.5, 0.5, 0.5)
}

color_cyan :: #force_inline proc "contextless" () -> Color {
	return make_color_rgb(68, 220, 235)
}
