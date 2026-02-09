package cute_framework

import "core:c"

Png :: struct {
	path: cstring,
	id:   c.uint64_t,
	pix:  ^Pixel,
	w:    c.int,
	h:    c.int,
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	png_cache_load :: proc(png_path: cstring, png: ^Png = nil) -> Result ---
}
