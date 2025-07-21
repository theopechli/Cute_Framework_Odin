package cute_framework

// @todo: Support Windows.
// @todo: Support Darwin.
when ODIN_OS == .Windows {
	@(export) foreign import lib {
		"./windows/cute.lib",
	}
} else when ODIN_OS == .Linux {
	@(export) foreign import lib {
		"system:stdc++",
		"./linux/libcute.so",
		"./linux/libphysfs.a",
		"./linux/libcute-shader.a",
		"./linux/libOSDependent.a",
		"./linux/libMachineIndependent.a",
		"./linux/libGenericCodeGen.a",
		"./linux/libglslang.a",
		"./linux/libglslang-default-resource-limits.a",
		"./linux/libs2n.a",
		"./linux/libSDL_uclibc.a",
		"./linux/libSPIRV.a",
		"./linux/libSPIRV-Tools-shared.so",
		"./linux/libSPIRV-Tools-opt.a",
		"./linux/libSPIRV-Tools.a",
		"./linux/libSPIRV-Tools-diff.a",
		"./linux/libSPIRV-Tools-link.a",
		"./linux/libSPIRV-Tools-lint.a",
		"./linux/libSPIRV-Tools-reduce.a",
		"./linux/libspirv-cross-c.a",
		"./linux/libspirv-cross-core.a",
		"./linux/libspirv-cross-glsl.a",
		"./linux/libspirv-cross-hlsl.a",
		"./linux/libspirv-cross-msl.a",
		"./linux/libSPVRemapper.a",
	}
} else when ODIN_OS == .Darwin {
	@(export) foreign import lib {
		"system:stdc++",
		"./darwin/libcute.a",
		"./darwin/libphysfs.a",
		"./darwin/libcute-shader.a",
		"./darwin/libOSDependent.a",
		"./darwin/libMachineIndependent.a",
		"./darwin/libGenericCodeGen.a",
		"./darwin/libglslang.a",
		"./darwin/libglslang-default-resource-limits.a",
		"./darwin/libs2n.a",
		"./darwin/libSDL3.so",
		"./darwin/libSDL_uclibc.a",
		"./darwin/libSPIRV.a",
		"./darwin/libSPIRV-Tools-opt.a",
		"./darwin/libSPIRV-Tools.a",
		"./darwin/libSPIRV-Tools-diff.a",
		"./darwin/libSPIRV-Tools-link.a",
		"./darwin/libSPIRV-Tools-lint.a",
		"./darwin/libSPIRV-Tools-reduce.a",
		"./darwin/libspirv-cross-c.a",
		"./darwin/libspirv-cross-core.a",
		"./darwin/libspirv-cross-glsl.a",
		"./darwin/libspirv-cross-hlsl.a",
		"./darwin/libspirv-cross-msl.a",
		"./darwin/libSPVRemapper.a",
	}
}
