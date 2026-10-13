package fs

FS_WASM_LIB :: #config(FS_WASM_LIB, "libfs.a")

@(export) foreign import lib { FS_WASM_LIB }

@(link_prefix = "fs_", default_calling_convention = "c")
foreign lib {
	init :: proc() ---
	sync :: proc() ---
}
