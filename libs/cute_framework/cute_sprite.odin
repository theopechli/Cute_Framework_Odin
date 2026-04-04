package cute_framework

import "core:c"

PlayDirection :: enum c.int {
	FORWARDS,
	BACKWARDS,
	PINGPONG,
}

SpriteSlice :: struct {
	frame_index: c.int,
	name:        cstring,
	box:         Aabb,
}

Sprite :: struct {
	id:                    c.uint64_t,
	name:                  cstring,
	w:                     c.int,
	h:                     c.int,
	_image_id:             c.uint64_t,
	_pivot:                V2,
	_center_patch:         Aabb,
	scale:                 V2,
	offset:                V2,
	opacity:               c.float,
	frame_index:           c.int,
	loop_count:            c.int,
	play_speed_multiplier: c.float,
	paused:                bool,
	loop:                  bool,
	finished:              bool,
	t:                     c.float,
	easy_sprite_id:        c.uint64_t,
	play_direction:        PlayDirection,
	blend_index:           c.int,
	animation_name:        cstring,
	transform:             Transform,
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	sprite_defaults              :: proc() -> Sprite ---
	make_easy_sprite_from_png    :: proc(png_path: cstring, result_out: ^Result) -> Sprite ---
	make_easy_sprite_from_pixels :: proc(pixels: ^Pixel, w: c.int, h: c.int) -> Sprite ---
	easy_sprite_update_pixels    :: proc(sprite: ^Sprite, pixels: ^Pixel) ---
	easy_sprite_unload           :: proc(sprite: ^Sprite) ---
	make_sprite                  :: proc(aseprite_path: cstring) -> Sprite ---
	make_demo_sprite             :: proc() -> Sprite ---
	sprite_pivot                 :: proc(sprite: ^Sprite) -> V2 ---
}

sprite_get_scale_x :: #force_inline proc "c" (sprite: ^Sprite) -> c.float {
	assert_contextless(sprite != nil)
	return sprite.scale.x
}

sprite_get_scale_y :: #force_inline proc "c" (sprite: ^Sprite) -> c.float {
	assert_contextless(sprite != nil)
	return sprite.scale.y
}

sprite_set_scale   :: #force_inline proc "c" (sprite: ^Sprite, scale: V2) {
	assert_contextless(sprite != nil)
	sprite.scale = scale
}

sprite_set_loop    :: #force_inline proc "c" (sprite: ^Sprite, loop: bool) {
	assert_contextless(sprite != nil)
	sprite.loop = loop
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	sprite_update      :: proc(sprite: ^Sprite) ---
	sprite_reset       :: proc(sprite: ^Sprite) ---
	sprite_play        :: proc(sprite: ^Sprite, animation: cstring) ---
	sprite_frame_count :: proc(sprite: ^Sprite) -> c.int ---
	sprite_will_finish :: proc(sprite: ^Sprite) -> bool ---
}

sprite_pause :: #force_inline proc "c" (sprite: ^Sprite) {
	assert_contextless(sprite != nil)
	sprite.paused = true
}

sprite_unpause :: #force_inline proc "c" (sprite: ^Sprite) {
	assert_contextless(sprite != nil)
	sprite.paused = false
}

sprite_toggle_pause :: #force_inline proc "c" (sprite: ^Sprite) {
	assert_contextless(sprite != nil)
	sprite.paused = !sprite.paused
}

sprite_flip_x :: #force_inline proc "c" (sprite: ^Sprite) {
	assert_contextless(sprite != nil)
	sprite.scale.x *= -1.0
}

sprite_flip_y :: #force_inline proc "c" (sprite: ^Sprite) {
	assert_contextless(sprite != nil)
	sprite.scale.y *= -1.0
}
