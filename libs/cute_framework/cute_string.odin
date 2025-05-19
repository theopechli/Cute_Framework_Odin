package cute_framework

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	sintern :: proc(s: cstring) -> cstring ---
}
