package main

import "core:os"
import "core:strings"
import "core:fmt"

import cf "libs:cute_framework"
import imgui "libs:cimgui"

main :: proc() {
	result := cf.make_app(
		"Fancy Window Title",
		0,
		0,
		0,
		640,
		480,
		{.Window_Position_Centered},
		strings.clone_to_cstring(os.args[0]),
	)
	if cf.is_error(result) {
		fmt.println("Error: ", result.details)
		return
	}

	cf.set_target_framerate(60)

	when ODIN_DEBUG {
		cf.app_init_imgui()
	}

	for cf.app_is_running() {
		cf.app_update()

		// All your game logic and updates go here...
		{
			if cf.key_just_pressed(.Escape) {
				cf.app_signal_shutdown()
			}

			render_imgui()
		}

		cf.app_draw_onto_screen(true)
	}

	cf.destroy_app()
}

render_imgui :: proc() {
	if imgui.begin("Info", nil, {.Always_Auto_Resize}) {
		if imgui.collapsing_header("Performance", imgui.TREE_NODE_FLAGS_COLLAPSING_HEADER + {.Default_Open}) {
			imgui.text("FPS: %0.3f", cf.app_get_framerate())
		}
	}
	imgui.end()
}
