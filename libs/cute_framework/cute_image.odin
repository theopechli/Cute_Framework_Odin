package cute_framework

import "core:c"

Image :: struct {
	w: c.int,
	h: c.int,
	pix: [^]Pixel,
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	image_load_png :: proc(virtual_path: cstring, img: ^Image) -> Result ---
	image_free     :: proc(img: ^Image) ---
}
