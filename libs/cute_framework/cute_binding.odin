package cute_framework

import "core:c"

ButtonBinding :: struct { id: c.uint64_t }
AxisBinding   :: struct { id: c.uint64_t }
StickBinding  :: struct { id: c.uint64_t }

AxisConflict :: enum c.int {
	NEWEST,
	OLDEST,
	CANCEL,
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	make_button_binding              :: proc(player_index: c.int, press_buffer: c.float) -> ButtonBinding ---
	destroy_button_binding           :: proc(b: ButtonBinding) ---
	button_binding_add_key           :: proc(b: ButtonBinding, key: KeyButton) ---
	button_binding_add_mouse_button  :: proc(b: ButtonBinding, button: MouseButton) ---
	button_binding_add_joypad_button :: proc(b: ButtonBinding, button: JoypadButton) ---
	button_binding_add_trigger       :: proc(b: ButtonBinding, axis: JoypadAxis, threshold: c.float, positive: c.bool) ---
	button_binding_pressed           :: proc(b: ButtonBinding) -> c.bool ---
	button_binding_released          :: proc(b: ButtonBinding) -> c.bool ---
	button_binding_down              :: proc(b: ButtonBinding) -> c.bool ---
	button_binding_value             :: proc(b: ButtonBinding) -> c.float ---
	button_binding_sign              :: proc(b: ButtonBinding) -> c.float ---
	button_binding_consume_press     :: proc(b: ButtonBinding) -> c.bool ---
	button_binding_consume_release   :: proc(b: ButtonBinding) -> c.bool ---
	button_binding_set_deadzone      :: proc(b: ButtonBinding, deadzone: c.float) ---
	button_binding_value_raw         :: proc(b: ButtonBinding) -> c.float ---
	button_binding_set_repeat        :: proc(b: ButtonBinding, delay: c.float, interval: c.float) ---
	button_binding_repeated          :: proc(b: ButtonBinding) -> c.bool ---
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	make_axis_binding               :: proc(player_index: c.int) -> AxisBinding ---
	destroy_axis_binding            :: proc(a: AxisBinding) ---
	axis_binding_add_keys           :: proc(a: AxisBinding, negative: KeyButton, positive: KeyButton) ---
	axis_binding_add_mouse_buttons  :: proc(a: AxisBinding, negative: MouseButton, positive: MouseButton) ---
	axis_binding_add_joypad_buttons :: proc(a: AxisBinding, negative: JoypadButton, positive: JoypadButton) ---
	axis_binding_add_triggers       :: proc(a: AxisBinding, negative: JoypadAxis, positive: JoypadAxis, threshold: c.float) ---
	axis_binding_add_left_stick_x   :: proc(a: AxisBinding, threshold: c.float) ---
	axis_binding_add_left_stick_y   :: proc(a: AxisBinding, threshold: c.float) ---
	axis_binding_add_right_stick_x  :: proc(a: AxisBinding, threshold: c.float) ---
	axis_binding_add_right_stick_y  :: proc(a: AxisBinding, threshold: c.float) ---
	axis_binding_set_conflict       :: proc(a: AxisBinding, mode: AxisConflict) ---
	axis_binding_pressed            :: proc(a: AxisBinding) -> c.bool ---
	axis_binding_released           :: proc(a: AxisBinding) -> c.bool ---
	axis_binding_value              :: proc(a: AxisBinding) -> c.float ---
	axis_binding_sign               :: proc(a: AxisBinding) -> c.float ---
	axis_binding_consume_press      :: proc(a: AxisBinding) -> c.bool ---
	axis_binding_consume_release    :: proc(a: AxisBinding) -> c.bool ---
	axis_binding_set_deadzone       :: proc(a: AxisBinding, deadzone: c.float) ---
	axis_binding_value_raw          :: proc(a: AxisBinding) -> c.float ---
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	make_stick_binding                  :: proc(player_index: c.int) -> StickBinding ---
	destroy_stick_binding               :: proc(s: StickBinding) ---
	stick_binding_add_keys              :: proc(s: StickBinding, up: KeyButton, down: KeyButton, left: KeyButton, right: KeyButton) ---
	stick_binding_add_wasd              :: proc(s: StickBinding) ---
	stick_binding_add_arrow_keys        :: proc(s: StickBinding) ---
	stick_binding_add_dpad              :: proc(s: StickBinding) ---
	stick_binding_add_left_stick        :: proc(s: StickBinding, threshold: c.float) ---
	stick_binding_add_right_stick       :: proc(s: StickBinding, threshold: c.float) ---
	stick_binding_pressed               :: proc(s: StickBinding) -> c.bool ---
	stick_binding_released              :: proc(s: StickBinding) -> c.bool ---
	stick_binding_value                 :: proc(s: StickBinding) -> V2 ---
	stick_binding_sign                  :: proc(s: StickBinding) -> V2 ---
	stick_binding_consume_press         :: proc(s: StickBinding) -> c.bool ---
	stick_binding_consume_release       :: proc(s: StickBinding) -> c.bool ---
	stick_binding_set_circular_deadzone :: proc(s: StickBinding, deadzone: c.float) ---
	stick_binding_value_raw             :: proc(s: StickBinding) -> V2 ---
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	register_joypad_connect_callback :: proc(fn: proc "c" (player_index: c.int, connected: c.bool, udata: rawptr), udata: rawptr) ---
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	binding_get_deadzone :: proc() -> c.float ---
	binding_set_deadzone :: proc(deadzone: c.float) ---
}

binding_pressed :: proc{
	button_binding_pressed,
	axis_binding_pressed,
	stick_binding_pressed,
}

binding_released :: proc{
	button_binding_released,
	axis_binding_released,
	stick_binding_released,
}

binding_value :: proc{
	button_binding_value,
	axis_binding_value,
	stick_binding_value,
}

binding_sign :: proc{
	button_binding_sign,
	axis_binding_sign,
	stick_binding_sign,
}

binding_consume_press :: proc{
	button_binding_consume_press,
	axis_binding_consume_press,
	stick_binding_consume_press,
}

binding_consume_release :: proc{
	button_binding_consume_release,
	axis_binding_consume_release,
	stick_binding_consume_release,
}

binding_value_raw :: proc{
	button_binding_value_raw,
	axis_binding_value_raw,
	stick_binding_value_raw,
}

binding_set_deadzone_per :: proc{
	button_binding_set_deadzone,
	axis_binding_set_deadzone,
}

destroy_binding :: proc{
	destroy_button_binding,
	destroy_axis_binding,
	destroy_stick_binding,
}
