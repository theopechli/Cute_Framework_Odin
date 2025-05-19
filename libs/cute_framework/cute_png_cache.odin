package cute_framework

import "core:c"

PNG :: struct {
	path: cstring,
	id:   u64,
	pix:  ^Pixel,
	w:    c.int,
	h:    c.int,
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	png_cache_load :: proc(png_path: cstring, png: ^PNG = nil) -> Result ---
}
