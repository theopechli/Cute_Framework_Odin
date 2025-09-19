package cute_framework

import "core:c"

On_Update_Fn :: proc "c" (udata: rawptr)

Stopwatch :: struct {
	start_time: u64,
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	@(link_prefix="CF_")
	DELTA_TIME: f32

	@(link_prefix="CF_")
	DELTA_TIME_FIXED: f32

	@(link_prefix="CF_")
	DELTA_TIME_INTERPOLANT: f32

	set_fixed_timestep :: proc(frames_per_second: c.int) ---
	set_fixed_timestep_max_updates :: proc(max_updates: c.int) ---
	set_target_framerate :: proc(frames_per_second: c.int) ---
	set_update_udata :: proc(udata: rawptr) ---
	pause_for :: proc(seconds: f32) ---
	on_interval :: proc(interval: f32, offset: f32 = 0.0) -> bool ---
	between_interval :: proc(interval: f32, offset: f32 = 0.0) -> bool ---
	is_paused :: proc() -> bool ---
	sleep :: proc(milliseconds: i32) ---
	make_stopwatch :: proc() -> Stopwatch ---
	stopwatch_seconds :: proc(stopwatch: Stopwatch) -> f64 ---
	stopwatch_milliseconds :: proc(stopwatch: Stopwatch) -> f64 ---
	stopwatch_microseconds :: proc(stopwatch: Stopwatch) -> f64 ---
}
