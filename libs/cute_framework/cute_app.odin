package cute_framework

import "core:c"

DisplayID :: distinct c.uint32_t

AppOptionFlags :: distinct bit_set[AppOptionFlagBits; c.int]
AppOptionFlagBits :: enum c.int {
	NO_GFX_BIT,
	FULLSCREEN_BIT,
	RESIZABLE_BIT,
	HIDDEN_BIT,
	WINDOW_POS_CENTERED_BIT,
	FILE_SYSTEM_DONT_DEFAULT_MOUNT_BIT,
	NO_AUDIO_BIT,
	GFX_D3D11_BIT,
	GFX_D3D12_BIT,
	GFX_METAL_BIT,
	GFX_VULKAN_BIT,
	GFX_OPENGL_BIT,
	GFX_DEBUG_BIT,
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	default_display      :: proc() -> DisplayID ---
	display_width        :: proc(display_id: DisplayID) -> c.int ---
	display_height       :: proc(display_id: DisplayID) -> c.int ---
	display_refresh_rate :: proc(display_id: DisplayID) -> c.float ---
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	make_app :: proc(window_title: cstring, display_id: DisplayID, x: c.int, y: c.int, w: c.int, h: c.int, options: AppOptionFlags, argv0: cstring) -> Result ---
	destroy_app          :: proc() ---
	app_is_running       :: proc() -> bool ---
	app_signal_shutdown  :: proc() ---
	app_update           :: proc(on_update: OnUpdateFn = nil) ---
	app_draw_onto_screen :: proc(clear: bool = false) -> c.int ---
	app_get_size         :: proc(w: ^c.int, h: ^c.int) ---
	app_init_imgui       :: proc() -> rawptr ---
}

MSAA :: enum c.int {
	NONE,
	_2X,
	_4X,
	_8X,
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	app_set_msaa                       :: proc(sample_count: c.int) -> bool ---
	app_get_canvas                     :: proc() -> Canvas ---
	app_set_canvas_size                :: proc(w: c.int, h: c.int) ---
	app_get_canvas_width               :: proc() -> c.int ---
	app_get_canvas_height              :: proc() -> c.int ---
	app_set_vsync                      :: proc(true_turn_on_vsync: bool) ---
	app_set_vsync_mailbox              :: proc(true_turn_on_mailbox: bool) ---
	app_set_borderless_fullscreen_mode :: proc() ---
	app_get_framerate                  :: proc() -> c.float ---
}
