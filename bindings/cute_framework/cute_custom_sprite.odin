package cute_framework

import "core:c"

Frame :: struct {
	id:    c.uint64_t,
	delay: c.float,
}

Animation :: struct {
	name:           cstring,
	play_direction: PlayDirection,
	frames:         [^]Frame,
	frame_offset:   c.int,
}

Png :: struct {
	path: cstring,
	id:   c.uint64_t,
	pix:  [^]Pixel,
	w:    c.int,
	h:    c.int,
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	custom_sprite_load_png :: proc(png_path: cstring, png: ^Png = nil) -> Result ---
}
