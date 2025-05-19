package cute_framework

import "core:c"

On_Update_Fn :: proc(udata: rawptr)

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
}
