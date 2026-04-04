package cute_framework

@(require) import ck "../ckit"

map_get :: #force_inline proc "c" (m: [^]^$T, k: $I) -> ^T {
	return ck.map_get(m, k)
}
