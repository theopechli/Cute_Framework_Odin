package cute_framework

import "core:c"

Ahdr :: struct {
	size:      c.int,
	capacity:  c.int,
	is_static: bool,
	data:      cstring,
	cookie:    c.uint32_t,
}

ahdr :: #force_inline proc "c" (a: [^]$T) -> ^Ahdr {
	return ([^]Ahdr)(a)[-1:]
}

alen :: #force_inline proc "c" (a: [^]$T) -> c.int {
	return ahdr(a).size
}
