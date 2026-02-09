package cute_framework

import ck "../ckit"

sintern :: #force_inline proc "c" (s: cstring) -> cstring {
	return ck.sintern(s)
}
