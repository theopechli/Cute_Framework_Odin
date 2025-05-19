package cute_framework

import "core:c"

H_Slot :: struct {
	key_hash:   u32,
	item_index: c.int,
	base_count: c.int,
}

H_Hdr :: struct {
	key_size:         c.int,
	item_size:        c.int,
	item_capacity:    c.int,
	count:            c.int,
	slot_capacity:    c.int,
	slots:            [^]H_Slot,
	items_key:        rawptr,
	items_slot_index: ^c.int,
	return_index:     c.int,
	hidden_item:      rawptr,
	items_data:       rawptr,
	temp_key:         rawptr,
	temp_item:        rawptr,
	cookie:           u32,
}

hhdr :: #force_inline proc "contextless" (h: ^[^]$T) -> ^H_Hdr {
	ptr := ([^]uintptr)(h)[-1:]
	return ([^]H_Hdr)(ptr)[-1:]
}

hfind :: #force_inline proc "contextless" (h: ^[^]$T, key: $I) -> ^T {
	header := hhdr(h)
	key: u64 = (u64)((uintptr)((rawptr)(key)))
	index := hashtable_find_impl(header, key)
	ptr := ([^]uintptr)(h)[index]
	return (^T)(ptr)
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	hashtable_find_impl :: proc(table: ^H_Hdr, key: u64) -> c.int ---
}
