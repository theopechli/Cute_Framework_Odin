package cute_framework

import "core:c"

Color :: distinct [4]c.float

Pixel :: struct #raw_union {
	colors: [4]c.uint8_t,
	val:    c.uint32_t,
}

make_color_rgb_f  :: #force_inline proc "c" (r: c.float, g: c.float, b: c.float) -> Color { return Color { r, g, b, 1.0 } }
make_color_rgba_f :: #force_inline proc "c" (r: c.float, g: c.float, b: c.float, a: c.float) -> Color { return Color { r, g, b, a } }
make_color_rgb    :: #force_inline proc "c" (r: c.uint8_t, g: c.uint8_t, b: c.uint8_t) -> Color { return Color { cast(c.float)r / 255.0, cast(c.float)g / 255.0, cast(c.float)b / 255.0, 1.0 } }
make_pixel_rgb    :: #force_inline proc "c" (r: c.uint8_t, g: c.uint8_t, b: c.uint8_t) -> Pixel { return Pixel { colors = { r, g, b, 255 } } }

color_invisible   :: #force_inline proc "c" () -> Color { return make_color_rgba_f(0.0, 0.0, 0.0, 0.0) }
color_clear       :: #force_inline proc "c" () -> Color { return make_color_rgba_f(0.0, 0.0, 0.0, 0.0) }
color_black       :: #force_inline proc "c" () -> Color { return make_color_rgb_f(0.0, 0.0, 0.0) }
color_white       :: #force_inline proc "c" () -> Color { return make_color_rgb_f(1.0, 1.0, 1.0) }
color_red         :: #force_inline proc "c" () -> Color { return make_color_rgb_f(1.0, 0.0, 0.0) }
color_grey        :: #force_inline proc "c" () -> Color { return make_color_rgb_f(0.5, 0.5, 0.5) }
color_cyan        :: #force_inline proc "c" () -> Color { return make_color_rgb(68, 220, 235) }
