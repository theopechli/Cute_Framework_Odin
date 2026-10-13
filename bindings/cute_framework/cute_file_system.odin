package cute_framework

import "core:c"

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	fs_set_write_directory         :: proc(platform_dependent_directory: cstring) -> Result ---
	fs_mount                       :: proc(archive: cstring, mount_point: cstring, append_to_path: bool) -> Result ---
	fs_dismount                    :: proc(archive: cstring) -> Result ---
	fs_enumerate_directory         :: proc(virtual_path: cstring) -> [^]cstring ---
	fs_free_enumerated_directory   :: proc(directory_list: [^]cstring) ---
	fs_file_exists                 :: proc(virtual_path: cstring) -> bool ---
	fs_read_entire_file_to_memory  :: proc(virtual_path: cstring, size: ^c.size_t) -> rawptr ---
	fs_write_entire_buffer_to_file :: proc(virtual_path: cstring, data: rawptr, size: c.size_t) -> Result ---
}
