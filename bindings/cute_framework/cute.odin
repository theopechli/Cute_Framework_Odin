package cute_framework

when ODIN_OS == .JS {
	CF_WASM_LIB :: #config(CF_WASM_LIB, "./lib/web/release/libcute.a")
	@(export) foreign import lib { CF_WASM_LIB }
} else when ODIN_OS == .Windows {
	when ODIN_DEBUG {
		@(export) foreign import lib { "./lib/desktop/debug/cute.lib" }
	} else {
		@(export) foreign import lib { "./lib/desktop/release/cute.lib" }
	}
} else when ODIN_DEBUG {
	@(export) foreign import lib {
		"./lib/desktop/debug/libcute.so",
		"./lib/desktop/debug/libphysfs.so",
		"./lib/desktop/debug/libs2n.a",
		"./lib/desktop/debug/libSDL3.so",
		"./lib/desktop/debug/libSDL_uclibc.a",
	}
} else {
	@(export) foreign import lib {
		"system:crypto",
		"system:stdc++",
		"./lib/desktop/release/libcute.a",
		"./lib/desktop/release/libphysfs.a",
		"./lib/desktop/release/libs2n.a",
		"./lib/desktop/release/libSDL3.a",
		"./lib/desktop/release/libSDL_uclibc.a",
	}
}
