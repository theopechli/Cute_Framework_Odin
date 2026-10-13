package cute_framework

import "core:c"

JoypadPowerLevel :: enum c.int {
	UNKNOWN,
	EMPTY,
	LOW,
	MEDIUM,
	FULL,
	WIRED,
	COUNT,
}

JoypadButton :: enum c.int {
	INVALID = -1,
	A,
	B,
	X,
	Y,
	BACK,
	GUIDE,
	START,
	LEFTSTICK,
	RIGHTSTICK,
	LEFTSHOULDER,
	RIGHTSHOULDER,
	DPAD_UP,
	DPAD_DOWN,
	DPAD_LEFT,
	DPAD_RIGHT,
	COUNT,
}

JoypadAxis :: enum c.int {
	INVALID = -1,
	LEFTX,
	LEFTY,
	RIGHTX,
	RIGHTY,
	TRIGGERLEFT,
	TRIGGERRIGHT,
}

JoypadType :: enum c.int {
	UNKNOWN,
	XBOX360,
	XBOXONE,
	PS3,
	PS4,
	NINENTDO_SWITCH_PRO,
	VIRTUAL,
	PS5,
	AMAZON_LUNA,
	GOOGLE_STADIA,
	NVIDIA_SHIELD,
	NINTENDO_SWITCH_JOYCON_LEFT,
	NINTENDO_SWITCH_JOYCON_RIGHT,
	NINTENDO_SWITCH_JOYCON_PAIR,
	COUNT,
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	joypad_add_mapping          :: proc(mapping: cstring) -> Result ---
	joypad_count                :: proc() -> c.int ---
	joypad_is_connected         :: proc(player_index: c.int) -> c.bool ---
	joypad_power_level          :: proc(player_index: c.int) -> JoypadPowerLevel ---
	joypad_name                 :: proc(player_index: c.int) -> cstring ---
	joypad_type                 :: proc(player_index: c.int) -> JoypadType ---
	joypad_vendor               :: proc(player_index: c.int) -> c.uint16_t ---
	joypad_product_id           :: proc(player_index: c.int) -> c.uint16_t ---
	joypad_serial_number        :: proc(player_index: c.int) -> cstring ---
	joypad_firmware_version     :: proc(player_index: c.int) -> c.uint16_t ---
	joypad_product_version      :: proc(player_index: c.int) -> c.uint16_t ---
	joypad_button_down          :: proc(player_index: c.int, button: JoypadButton) -> c.bool ---
	joypad_button_just_pressed  :: proc(player_index: c.int, button: JoypadButton) -> c.bool ---
	joypad_button_just_released :: proc(player_index: c.int, button: JoypadButton) -> c.bool ---
	joypad_axis                 :: proc(player_index: c.int, axis: JoypadAxis) -> c.int16_t ---
	joypad_axis_prev            :: proc(player_index: c.int, axis: JoypadAxis) -> c.int16_t ---
	joypad_rumble               :: proc(player_index: c.int, lo_frequency_rumble: c.uint16_t, hi_frequency_rumble: c.uint16_t, duration_ms: c.int) ---
}
