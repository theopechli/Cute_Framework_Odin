package cute_framework

import "core:c"

Sound :: struct { id: c.uint64_t }
Audio :: struct { id: c.uint64_t }

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	audio_load_wav :: proc(path: cstring) -> Audio ---
	audio_destroy  :: proc(audio: Audio) ---
}

SoundParams :: struct {
	paused:       bool,
	looped:       bool,
	volume:       c.float,
	pan:          c.float,
	pitch:        c.float,
	sample_index: c.int,
}

sound_params_defaults :: #force_inline proc "c" () -> SoundParams {
	return SoundParams {
		volume = 1.0,
		pan    = 0.5,
		pitch  = 1.0,
	}
}

@(link_prefix = "cf_", default_calling_convention = "c")
foreign lib {
	play_sound :: proc(audio_source: Audio, params: SoundParams) -> Sound ---
	sound_stop :: proc(sound: Sound) ---
}
