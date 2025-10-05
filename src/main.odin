package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:time"

import cf "libs:cute_framework"
@(require)
import imgui "libs:imgui"

main :: proc() {
	result := cf.make_app(
		"Fancy Window Title",
		0,
		0,
		0,
		640,
		480,
		{.Window_Position_Centered},
		strings.clone_to_cstring(os.args[0], context.temp_allocator),
	)
	if cf.is_error(result) {
		fmt.eprintln("CF error:", result.details)
		return
	}

	when ODIN_DEBUG {
		cf.app_init_imgui()
	}

	frame_time: f64

	for cf.app_is_running() {
		start := time.tick_now()

		cf.app_update()

		// All your game logic and updates go here...
		{
			if cf.key_just_pressed(.Escape) {
				cf.app_signal_shutdown()
			}

			when ODIN_DEBUG {
				if imgui.Begin("Stats", nil, {}) {
					imgui.Text("[%d FPS]", int(cf.app_get_framerate()))
					imgui.Text("[%f ms]", frame_time)
				}
				imgui.End()
			}
		}

		cf.app_draw_onto_screen(true)

		frame_time = time.duration_milliseconds(time.tick_since(start))
	}

	cf.destroy_app()
}
