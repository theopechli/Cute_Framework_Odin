package main_desktop

import "base:runtime"

import "core:log"
import "core:mem"
import "core:os"
import "core:strings"

import "../game"

main :: proc() {
	log_handle, err := os.open("game.log", os.O_RDWR | os.O_APPEND | os.O_CREATE, os.Permissions_Default_File)
	ensure(err == nil, "failed to open log file")

	file_logger := log.create_file_logger(log_handle)
	defer log.destroy_file_logger(file_logger)

	console_logger := log.create_console_logger()
	defer log.destroy_console_logger(console_logger)

	multi_logger := log.create_multi_logger(console_logger, file_logger)
	defer log.destroy_multi_logger(multi_logger)

	context.logger = multi_logger

	runtime.default_temp_allocator_init(&runtime.global_default_temp_allocator_data, 1*mem.Megabyte, context.allocator)
	defer runtime.default_temp_allocator_destroy(&runtime.global_default_temp_allocator_data)

	game.init(strings.clone_to_cstring(os.args[0]))
	defer game.fini()

	for game.should_run() {
		game.update()
	}
}
