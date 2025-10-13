package cute_framework

import "core:c"

@(link_prefix = "CF_", default_calling_convention = "c")
foreign lib {
	DELTA_TIME:             c.float
	DELTA_TIME_FIXED:       c.float
	DELTA_TIME_INTERPOLANT: c.float
}

OnUpdateFn :: #type proc "c" (udata: rawptr)

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	set_fixed_timestep             :: proc(frames_per_second: c.int) ---
	set_fixed_timestep_max_updates :: proc(max_updates: c.int) ---
	set_target_framerate           :: proc(frames_per_second: c.int) ---
	set_update_udata               :: proc(udata: rawptr) ---
	pause_for                      :: proc(seconds: c.float) ---
	on_interval                    :: proc(interval: c.float, offset: c.float = 0.0) -> bool ---
	between_interval               :: proc(interval: c.float, offset: c.float = 0.0) -> bool ---
	is_paused                      :: proc() -> bool ---
	sleep                          :: proc(milliseconds: c.int) ---
}

Stopwatch :: struct {
	start_time: c.uint64_t,
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	make_stopwatch         :: proc() -> Stopwatch ---
	stopwatch_seconds      :: proc(stopwatch: Stopwatch) -> c.double ---
	stopwatch_milliseconds :: proc(stopwatch: Stopwatch) -> c.double ---
	stopwatch_microseconds :: proc(stopwatch: Stopwatch) -> c.double ---
}
