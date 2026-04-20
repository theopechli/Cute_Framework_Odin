package cute_framework

when ODIN_OS == .Windows {
	@(export) foreign import lib {
		"./lib/cute.lib",
	}
} else {
	@(export) foreign import lib {
		"system:stdc++",
		"system:zstd",
		"system:z",
		"./lib/libcute.so",
	}
}
