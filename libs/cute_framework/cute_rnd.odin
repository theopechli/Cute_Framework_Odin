package cute_framework

Rnd :: struct {
	state: [2]u64,
}

internal_rnd_murmur3_avalanche64 :: #force_inline proc "contextless" (h: u64) -> u64 {
	h := h
	h ~= h >> 33
	h *= 0xff51afd7ed558ccd
	h ~= h >> 33
	h *= 0xc4ceb9fe1a85ec53
	h ~= h >> 33
	return h
}

rnd_seed :: #force_inline proc "contextless" (seed: u64) -> Rnd {
	rnd: Rnd
	value := internal_rnd_murmur3_avalanche64((seed << u64(1)) | u64(1))
	rnd.state[0] = value
	rnd.state[1] = internal_rnd_murmur3_avalanche64(value)
	return rnd
}

rnd_uint64 :: #force_inline proc "contextless" (rnd: ^Rnd) -> u64 {
	x := rnd.state[0]
	y := rnd.state[0]
	rnd.state[0] = y
	x ~= x << 23
	x ~= x >> 17
	x ~= y ~ ( y >> 26)
	rnd.state[1] = x
	return x + y
}

rnd_float :: #force_inline proc "contextless" (rnd: ^Rnd) -> f32 {
	value := u32(rnd_uint64(rnd) >> 32)

	exponent: u32 = 127
	mantissa: u32 = value >> 9
	result: u32 = (exponent << 23) | mantissa
	return (cast(^f32)&result)^ - 1.0
}

rnd_range_float :: #force_inline proc "contextless" (rnd: ^Rnd, lo: f32, hi: f32) -> f32 {
	range := hi - lo
	value := rnd_float(rnd) * range
	return lo + value
}
