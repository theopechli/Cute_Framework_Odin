package cute_framework

import "core:c"
import la "core:math/linalg"

Frame :: struct {
	id:    u64,
	delay: f32,
}

Play_Direction :: enum c.int {
	Forwards,
	Backwards,
	Ping_Pong,
}

Animation :: struct {
	name:           cstring,
	play_direction: Play_Direction,
	frames:         [^]Frame,
	frame_offset:   c.int,
}

Sprite_Slice :: struct {
	frame_index: c.int,
	name:        cstring,
	box:         AABB,
}

Sprite :: struct {
	name:                  cstring,
	w:                     c.int,
	h:                     c.int,
	scale:                 la.Vector2f32,
	offset:                la.Vector2f32,
	pivots:                [^]la.Vector2f32,
	slices:                [^]Sprite_Slice,
	opacity:               f32,
	frame_index:           c.int,
	loop_count:            c.int,
	play_speed_multiplier: f32,
	paused:                bool,
	loop:                  bool,
	t:                     f32,
	easy_sprite_id:        u64,
	play_direction:        Play_Direction,
	animation:             ^Animation,
	animations:            ^[^]Animation,
	transform:             Transform,
}

sprite_defaults :: #force_inline proc "contextless" () -> Sprite {
	return Sprite {
		scale                 = {1, 1},
		opacity               = 1.0,
		play_speed_multiplier = 1.0,
		transform             = make_transform(),
		loop                  = true,
	}
}

sprite_update :: #force_inline proc(sprite: ^Sprite) {
	assert(sprite != nil)
	if sprite.paused {
		return
	}
	if sprite.animation == nil {
		return
	}

	sprite.t += DELTA_TIME * sprite.play_speed_multiplier
	frame_count: i32 = alen(sprite.animation.frames)
	direction := sprite.play_direction
	if direction == .Forwards {
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
	} else if direction == .Backwards {
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
	} else if direction == .Ping_Pong {
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

sprite_reset :: #force_inline proc(sprite: ^Sprite) {
	assert(sprite != nil)
	sprite.paused = false
	sprite.frame_index = 0
	sprite.loop_count = 0
	sprite.t = 0
	if sprite.animation != nil {
		sprite.play_direction = sprite.animation.play_direction
	}
}

sprite_play :: #force_inline proc(sprite: ^Sprite, animation: cstring) {
	assert(sprite != nil)
	if sprite.animations == nil {
		return
	}
	sprite.animation = hfind(sprite.animations, sintern(animation))
	assert(sprite.animation != nil)
	sprite_reset(sprite)
}

sprite_flip_x :: #force_inline proc(sprite: ^Sprite) {
	assert(sprite != nil)
	sprite.scale.x *= -1.0
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	make_sprite :: proc(aseprite_path: cstring) -> Sprite ---
}
