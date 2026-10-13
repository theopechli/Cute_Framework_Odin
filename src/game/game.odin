package game

import "core:log"
import la "core:math/linalg"
import "core:time"

import cf "cf:cute_framework"
@(require) import imgui "cf:imgui"

WINDOW_TITLE  :: "Game"
WINDOW_WIDTH  :: 640
WINDOW_HEIGHT :: 360

Vec2 :: [2]f32

Position :: Vec2
Velocity :: Vec2

Player :: struct {
	pos:   Position,
	vel:   Velocity,
	speed: f32,
}

Context :: struct {
	player: Player,
	frame_time: f64,
}

g_ctx: ^Context

init :: proc(argv0: cstring) {
	log.debug("initializing game")

	options := cf.AppOptionFlags{.WINDOW_POS_CENTERED_BIT}

	when ODIN_OS == .JS {
		options += {.FILE_SYSTEM_DONT_DEFAULT_MOUNT_BIT}
	}

	result := cf.make_app(
		WINDOW_TITLE,
		0,
		0,
		0,
		WINDOW_WIDTH,
		WINDOW_HEIGHT,
		options,
		argv0,
	)
	if cf.is_error(result) {
		log.panic("failed to make CF app:", result.details)
	}

	when ODIN_DEBUG {
		cf.app_init_imgui()
	}

	cf.clear_color(0.1, 0.1, 0.2, 1.0)

	g_ctx = new(Context)
	g_ctx.player.speed = 200.0

	log.debug("game initialized")
}

fini :: proc() {
	cf.destroy_app()
}

update :: proc() {
	start := time.tick_now()

	cf.app_update()

	if cf.key_just_pressed(.KEY_ESCAPE) {
		cf.app_signal_shutdown()
	}

	dir: Vec2
	if cf.key_down(.KEY_W) {
		dir.y += 1
	}
	if cf.key_down(.KEY_S) {
		dir.y -= 1
	}
	if cf.key_down(.KEY_A) {
		dir.x -= 1
	}
	if cf.key_down(.KEY_D) {
		dir.x += 1
	}
	dir = la.normalize0(dir)

	player := &g_ctx.player
	player.vel = dir * player.speed
	player.pos += player.vel * cf.DELTA_TIME

	when ODIN_DEBUG {
		if imgui.Begin("Stats", nil, {}) {
			imgui.Text("FPS: %.2f", cf.app_get_framerate())
			imgui.Text("Frame Time (ms): %.2f", g_ctx.frame_time)
		}
		imgui.End()
	}

	cf.draw_push()

	cf.draw_TSR(cf.V2(player.pos), {1.0, 1.0}, {})

	cf.draw_push_glow(cf.color_red(), 10.0)
	cf.draw_push_color(cf.color_red())
	cf.draw_circle(cf.make_circle({}, 20.0), 1.0)
	cf.draw_pop_color()
	cf.draw_pop_glow()

	cf.draw_pop()

	cf.app_draw_onto_screen(true)

	g_ctx.frame_time = time.duration_milliseconds(time.tick_since(start))
}

should_run :: proc() -> bool {
	return cf.app_is_running()
}
