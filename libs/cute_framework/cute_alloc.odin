package cute_framework

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	free :: proc(ptr: rawptr) ---
}
