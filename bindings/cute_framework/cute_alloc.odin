package cute_framework

import "core:c"

Allocator :: struct {
	udata:      rawptr,
	alloc_fn:   proc "c" (size: c.size_t, udata: rawptr) -> rawptr,
	free_fn:    proc "c" (ptr: rawptr, udata: rawptr),
	calloc_fn:  proc "c" (size: c.size_t, count: c.size_t, udata: rawptr) -> rawptr,
	realloc_fn: proc "c" (ptr: rawptr, size: c.size_t, udata: rawptr) -> rawptr,
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	allocator_override        :: proc(allocator: Allocator) ---
	allocator_restore_default :: proc() ---
	alloc                     :: proc(size: c.size_t) -> rawptr ---
	free                      :: proc(ptr: rawptr) ---
	calloc                    :: proc(size: c.size_t, count: c.size_t) -> rawptr ---
	realloc                   :: proc(ptr: rawptr, size: c.size_t) -> rawptr ---
}
