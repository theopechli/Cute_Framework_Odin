package cute_framework

import "core:c"

Hslot :: struct {
	key_hash:   c.uint32_t,
	item_index: c.int,
	base_count: c.int,
}

Hhdr :: struct {
	key_size:         c.int,
	item_size:        c.int,
	item_capacity:    c.int,
	count:            c.int,
	slot_capacity:    c.int,
	slots:            [^]Hslot,
	items_key:        rawptr,
	items_slot_index: ^c.int,
	return_index:     c.int,
	hidden_item:      rawptr,
	items_data:       rawptr,
	temp_key:         rawptr,
	temp_item:        rawptr,
	cookie:           c.uint32_t,
}

hhdr :: #force_inline proc "c" (h: ^[^]$T) -> ^Hhdr {
	ptr := ([^]uintptr)(h)[-1:]
	return ([^]Hhdr)(ptr)[-1:]
}

hfind :: #force_inline proc "c" (h: ^[^]$T, key: $I) -> ^T {
	header := hhdr(h)
	key: c.uint64_t = cast(c.uint64_t)(cast(uintptr)(cast(rawptr)key))
	index := hashtable_find_impl(header, key)
	ptr := ([^]uintptr)(h)[index]
	return (^T)(ptr)
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	hashtable_find_impl :: proc(table: ^Hhdr, key: c.uint64_t) -> c.int ---
}
