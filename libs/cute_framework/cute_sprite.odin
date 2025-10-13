package cute_framework

import "base:runtime"

import "core:c"

Frame :: struct {
	id:    c.uint64_t,
	delay: c.float,
}

PlayDirection :: enum c.int {
	FORWARDS,
	BACKWARDS,
	PINGPONG,
}

Animation :: struct {
	name:           cstring,
	play_direction: PlayDirection,
	frames:         [^]Frame,
	frame_offset:   c.int,
}

SpriteSlice :: struct {
	frame_index: c.int,
	name:        cstring,
	box:         Aabb,
}

Sprite :: struct {
	name:                  cstring,
	w:                     c.int,
	h:                     c.int,
	scale:                 V2,
	offset:                V2,
	pivots:                [^]V2,
	slices:                [^]SpriteSlice,
	opacity:               c.float,
	frame_index:           c.int,
	loop_count:            c.int,
	play_speed_multiplier: c.float,
	paused:                bool,
	loop:                  bool,
	t:                     c.float,
	easy_sprite_id:        c.uint64_t,
	play_direction:        PlayDirection,
	animation:             ^Animation,
	animations:            ^[^]Animation,
	transform:             Transform,
}

sprite_defaults :: #force_inline proc "c" () -> Sprite {
	return Sprite {
		scale                 = V2 { 1.0, 1.0 },
		opacity               = 1.0,
		play_speed_multiplier = 1.0,
		transform             = make_transform(),
		loop                  = true,
	}
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	make_sprite      :: proc(aseprite_path: cstring) -> Sprite ---
	make_demo_sprite :: proc() -> Sprite ---
}

sprite_get_scale_x :: #force_inline proc "c" (sprite: ^Sprite) -> c.float {
	context = runtime.default_context()
	assert(sprite != nil)
	return sprite.scale.x
}

sprite_get_scale_y :: #force_inline proc "c" (sprite: ^Sprite) -> c.float {
	context = runtime.default_context()
	assert(sprite != nil)
	return sprite.scale.y
}

sprite_set_scale   :: #force_inline proc "c" (sprite: ^Sprite, scale: V2) {
	context = runtime.default_context()
	assert(sprite != nil)
	sprite.scale = scale
}

sprite_set_loop    :: #force_inline proc "c" (sprite: ^Sprite, loop: bool) {
	context = runtime.default_context()
	assert(sprite != nil)
	sprite.loop = loop
}

sprite_update :: #force_inline proc "c" (sprite: ^Sprite) {
	context = runtime.default_context()
	assert(sprite != nil)
	if sprite.paused {
		return
	}
	if sprite.animation == nil {
		return
	}

	sprite.t += DELTA_TIME * sprite.play_speed_multiplier
	frame_count: c.int = alen(sprite.animation.frames)
	direction := sprite.play_direction
	if direction == .FORWARDS {
		if sprite.t >= sprite.animation.frames[sprite.frame_index].delay {
			sprite.frame_index += 1
			sprite.t = 0
			if sprite.frame_index == frame_count {
				if sprite.loop {
					sprite.loop_count += 1
					sprite.frame_index = 0
				} else {
					sprite.frame_index -= 1
				}
			}
		}
	} else if direction == .BACKWARDS {
		if sprite.t >= sprite.animation.frames[sprite.frame_index].delay {
			sprite.frame_index -= 1
			sprite.t = 0
			if sprite.frame_index < 0 {
				if sprite.loop {
					sprite.loop_count += 1
					sprite.frame_index = frame_count - 1
				} else {
					sprite.frame_index += 1
				}
			}
		}
	} else if direction == .PINGPONG {
		if sprite.t >= sprite.animation.frames[sprite.frame_index].delay {
			sprite.t = 0
			if sprite.loop_count % 2 == 0 {
				sprite.frame_index -= 1
				if sprite.frame_index < 0 {
					if sprite.loop {
						sprite.loop_count += 1
						sprite.frame_index += 1
					} else  {
						sprite.frame_index = 0
					}
				}
			} else {
				sprite.frame_index += 1
				if sprite.frame_index == frame_count {
					sprite.loop_count += 1
					sprite.frame_index -= 1
				}
			}
		}
	}
}

sprite_reset :: #force_inline proc "c" (sprite: ^Sprite) {
	context = runtime.default_context()
	assert(sprite != nil)
	sprite.paused = false
	sprite.frame_index = 0
	sprite.loop_count = 0
	sprite.t = 0
	if sprite.animation != nil {
		sprite.play_direction = sprite.animation.play_direction
	}
}

sprite_play :: #force_inline proc "c" (sprite: ^Sprite, animation: cstring) {
	context = runtime.default_context()
	assert(sprite != nil)
	if sprite.animations == nil {
		return
	}
	sprite.animation = hfind(sprite.animations, sintern(animation))
	assert(sprite.animation != nil)
	sprite_reset(sprite)
}

sprite_pause :: #force_inline proc "c" (sprite: ^Sprite) {
	context = runtime.default_context()
	assert(sprite != nil)
	sprite.paused = true
}

sprite_unpause :: #force_inline proc "c" (sprite: ^Sprite) {
	context = runtime.default_context()
	assert(sprite != nil)
	sprite.paused = false
}

sprite_toggle_pause :: #force_inline proc "c" (sprite: ^Sprite) {
	context = runtime.default_context()
	assert(sprite != nil)
	sprite.paused = !sprite.paused
}

sprite_flip_x :: #force_inline proc "c" (sprite: ^Sprite) {
	context = runtime.default_context()
	assert(sprite != nil)
	sprite.scale.x *= -1.0
}

sprite_flip_y :: #force_inline proc "c" (sprite: ^Sprite) {
	context = runtime.default_context()
	assert(sprite != nil)
	sprite.scale.y *= -1.0
}

sprite_frame_count :: #force_inline proc "c" (sprite: ^Sprite) -> c.int {
	context = runtime.default_context()
	assert(sprite != nil)
	if sprite.animation == nil {
		return 0
	}
	return alen(sprite.animation.frames)
}

sprite_will_finish :: #force_inline proc "c" (sprite: ^Sprite) -> bool {
	context = runtime.default_context()
	assert(sprite != nil)
	// TODO -- Backwards and pingpong.
	if sprite.animation == nil {
		return false
	}
	if sprite.frame_index == sprite_frame_count(sprite) - 1 {
		return sprite.t + DELTA_TIME * sprite.play_speed_multiplier >= sprite.animation.frames[sprite.frame_index].delay
	} else {
		return false
	}
}
