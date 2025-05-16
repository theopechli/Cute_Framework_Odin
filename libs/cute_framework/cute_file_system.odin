package cute_framework

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	fs_set_write_directory :: proc(platform_dependent_directory: cstring) -> Result ---
	fs_mount :: proc(archive, mount_point: cstring, append_to_path: bool) -> Result ---
	fs_dismount :: proc(archive: cstring) -> Result ---
}
