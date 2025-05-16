package main

import "core:os"
import "core:strings"
import "core:fmt"

import cf "libs:cute_framework"

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
		fmt.println("Error: {}", result.details)
		return
	}

	cf.set_target_framerate(60)

	for cf.app_is_running() {
		cf.app_update()
		// All your game logic and updates go here...
		cf.app_draw_onto_screen()
	}

	cf.destroy_app()
}
