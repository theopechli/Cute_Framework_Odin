package cute_framework

import "core:c"

Display_ID :: u32

App_Option_Flags :: bit_set[App_Option_Flag; c.int]
App_Option_Flag :: enum c.int {
	No_GFX,
	Fullscreen,
	Resizable,
	Hidden,
	Window_Position_Centered,
	File_System_No_Default_Mount,
	No_Audio,
	GFX_D3D11,
	GFX_D3D12,
	GFX_Metal,
	GFX_Vulkan,
	GFX_Debug,
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	default_display :: proc() -> Display_ID ---
	display_width :: proc(display_id: Display_ID) -> c.int ---
	display_height :: proc(display_id: Display_ID) -> c.int ---
	display_refresh_rate :: proc(display_id: Display_ID) -> f32 ---
	make_app :: proc(window_title: cstring, display_id: Display_ID, x, y, w, h: c.int, options: App_Option_Flags, argv0: cstring) -> Result ---
	destroy_app :: proc() ---
	app_init_imgui :: proc() -> rawptr ---
	app_is_running :: proc() -> bool ---
	app_signal_shutdown :: proc() ---
	app_update :: proc(on_update: On_Update_Fn = nil) ---
	app_draw_onto_screen :: proc(clear: bool = false) -> c.int ---
	app_get_framerate :: proc() -> f32 ---
}
