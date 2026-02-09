package cute_framework

import "core:c"

import ck "../ckit"

asize :: #force_inline proc "c" (a: [^]$T) -> c.int {
	return ck.asize(a)
}
