package cute_framework

import "core:c"

RESULT_SUCCESS :: 0
RESULT_ERROR :: -1

Result :: struct {
	code: c.int,
	details: cstring,
}

is_error :: proc "c" (result: Result) -> bool { return result.code == RESULT_ERROR }
