package main_web

import "core:c"

// These are resolved at link time by emcc against emscripten's JS runtime
// (library_browser.js) -- no library needs to be named here.
@(default_calling_convention = "c")
foreign {
	emscripten_set_main_loop    :: proc(func: proc "c" (), fps: c.int, simulate_infinite_loop: c.int) ---
	emscripten_cancel_main_loop :: proc() ---
}
