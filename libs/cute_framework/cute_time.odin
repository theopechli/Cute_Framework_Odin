package cute_framework

import "core:c"

DELTA_TIME :: f32
DELTA_TIME_FIXED :: f32

On_Update_Fn :: proc(udata: rawptr)

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	set_fixed_timestep :: proc(frames_per_second: c.int) ---
	set_fixed_timestep_max_updates :: proc(max_updates: c.int) ---
	set_target_framerate :: proc(frames_per_second: c.int) ---
	set_update_udata :: proc(udata: rawptr) ---
}
