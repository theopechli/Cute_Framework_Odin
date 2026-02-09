package cute_framework

when ODIN_OS == .Windows {
	@(export) foreign import lib {
		"./lib/cute.lib",
		"./lib/cute-shader.lib",
		"./lib/glslang.lib",
		"./lib/glslang-default-resource-limits.lib",
		"./lib/s2n.lib",
		"./lib/SDL_uclibc.lib",
		"./lib/SPIRV.lib",
		"./lib/SPIRV-Tools-opt.lib",
		"./lib/SPIRV-Tools.lib",
		"./lib/spirv-cross-c.lib",
		"./lib/spirv-cross-core.lib",
		"./lib/spirv-cross-glsl.lib",
		"./lib/spirv-cross-hlsl.lib",
		"./lib/spirv-cross-msl.lib",
		"./lib/physfs.lib",
		"./lib/SDL3.dll",
		"../ckit/lib/ckit.lib",
	}
} else {
	@(export) foreign import lib {
		"system:stdc++",
		"system:zstd",
		"system:z",
		"./lib/libcute.so",
		"./lib/libcute-shader.a",
		"./lib/libglslang.a",
		"./lib/libglslang-default-resource-limits.a",
		"./lib/libs2n.a",
		"./lib/libSDL_uclibc.a",
		"./lib/libSPIRV.a",
		"./lib/libSPIRV-Tools-opt.a",
		"./lib/libSPIRV-Tools.a",
		"./lib/libspirv-cross-c.a",
		"./lib/libspirv-cross-core.a",
		"./lib/libspirv-cross-glsl.a",
		"./lib/libspirv-cross-hlsl.a",
		"./lib/libspirv-cross-msl.a",
		"./lib/libphysfs.so",
		"./lib/libSDL3.so",
		"../ckit/lib/ckit.a",
	}
}
