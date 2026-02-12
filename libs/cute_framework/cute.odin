package cute_framework

// FIXME: Test on Windows.
when ODIN_OS == .Windows {
	@(export) foreign import lib {
		"./lib/libcute.dll",
	}
} else {
	@(export) foreign import lib {
		"system:stdc++",
		"system:zstd",
		"system:z",
		"./lib/libcute.so",
	}
}
