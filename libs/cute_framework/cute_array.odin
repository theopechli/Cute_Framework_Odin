package cute_framework

import "core:c"

A_Hdr :: struct {
	size:      c.int,
	capacity:  c.int,
	is_static: bool,
	data:      cstring,
	cookie:    u32,
}

ahdr :: #force_inline proc "contextless" (a: [^]$T) -> ^A_Hdr {
	return ([^]A_Hdr)(a)[-1:]
}

alen :: #force_inline proc "contextless" (a: [^]$T) -> c.int {
	return ahdr(a).size
}
