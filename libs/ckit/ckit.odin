package ckit

// FIXME: Test on Windows.
when ODIN_OS == .Windows {
	foreign import lib {
		"./lib/ckit.lib",
		// "./lib/ckit.dll",
	}
} else {
	foreign import lib {
		"./lib/ckit.a",
		// "./lib/libckit.so",
	}
}

import "core:c"
import "core:c/libc"

asize :: #force_inline proc "c" (a: [^]$T) -> c.int {
	if a != nil {
		return AHDR(a).size
	}
	return 0
}

Cookie :: struct #raw_union {
	val: c.uint32_t,
	c:   [4]c.char,
}

ArrayHeader :: struct {
	size:      c.int,
	capacity:  c.int,
	is_static: c.int,
	data:      ^c.char,
	cookie:    Cookie,
}

@(private)
AHDR :: #force_inline proc "c" (a: [^]$T) -> ^ArrayHeader {
	return (^ArrayHeader)(uintptr(a) - size_of(ArrayHeader))
}

MapSlot :: struct {
	h:          c.uint64_t,
	item_index: c.int,
	base_count: c.int,
}

MAP_COOKIE :: u32('M') | (u32('A') << 8) | (u32('P') << 16) | (u32('!') << 24) // cookie('M', 'A', 'P', '!')

@(private)
MHDR :: #force_inline proc "c" (m: [^]$T) -> ^MapHeader {
	if m != nil {
		return (^MapHeader)(uintptr(rawptr(m)) - size_of(MapHeader))
	}
	return nil
}

@(private)
map_validate :: #force_inline proc "c" (m: [^]$T) {
	if m != nil {
		assert_contextless(MHDR(m).cookie.val == MAP_COOKIE)
	}
}

MapHeader :: struct {
	cookie:        Cookie,
	val_size:      c.int,
	size:          c.int,
	capacity:      c.int,
	slot_count:    c.int,
	slot_capacity: c.int,
}

map_get :: #force_inline proc "c" (m: [^]^$T, k: $I) -> ^T {
	map_validate(m)
	idx := map_find_impl(MHDR(m), transmute(c.uint64_t)k)
	if idx >= 0 {
		return m[idx]
	}
	return nil
}

@(default_calling_convention="c", link_prefix="ck_", require_results)
foreign lib {
	map_find_impl :: proc(hdr: ^MapHeader, key: c.uint64_t) -> c.int ---
}

@(default_calling_convention="c", link_prefix="ck_", require_results)
foreign lib {
	sintern_range :: proc(start: cstring, end: cstring) -> cstring ---
}

sintern :: #force_inline proc "c" (s: cstring) -> cstring {
	return sintern_range(s, cstring(&([^]u8)(rawptr(s))[libc.strlen(s)]))
}
