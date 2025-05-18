package cute_framework

import "core:c"
import la "core:math/linalg"

Frame :: struct {
	id:    u64,
	delay: f32,
}

Play_Directions :: bit_set[Play_Direction; c.int]
Play_Direction :: enum c.int {
	Forwards,
	Backwards,
	Ping_Pong,
}

Animation :: struct {
	name:           cstring,
	play_direction: Play_Directions,
	frames:         ^Frame,
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
	pivots:                ^la.Vector2f32,
	slices:                ^Sprite_Slice,
	opacity:               f32,
	frame_index:           c.int,
	loop_count:            c.int,
	play_speed_multiplier: f32,
	paused:                bool,
	loop:                  bool,
	t:                     f32,
	easy_sprite_id:        u64,
	play_direction:        Play_Directions,
	animation:             ^Animation,
	animations:            ^^Animation,
	transform:             Transform,
}

sprite_defaults :: #force_inline proc() -> Sprite {
	return Sprite {
		scale                 = {1, 1},
		opacity               = 1.0,
		play_speed_multiplier = 1.0,
		transform             = make_transform(),
		loop                  = true,
	}
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	make_sprite :: proc(aseprite_path: cstring) -> Sprite ---
}
