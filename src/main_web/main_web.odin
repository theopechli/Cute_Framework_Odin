package main_web

import "base:runtime"

import "core:mem"

import fs "cf:fs"

import "../game"

_web_context: runtime.Context

@export
main_start :: proc "c" () {
	context = runtime.default_context()

	context.allocator = emscripten_allocator()
	context.logger = create_emscripten_logger()

	runtime.default_temp_allocator_init(&runtime.global_default_temp_allocator_data, 1*mem.Megabyte, context.allocator)
	defer runtime.default_temp_allocator_destroy(&runtime.global_default_temp_allocator_data)

	_web_context = context

	fs.init()

	// The value here doesn't matter so long as it contains a `/` and a name, even
	// the `.` is optional.
	game.init("./game")
	emscripten_set_main_loop(update, 0, 1)
}

update :: proc "c" () {
	context = _web_context

	if !game.should_run() {
		emscripten_cancel_main_loop()
		game.fini()
		return
	}

	game.update()
}
