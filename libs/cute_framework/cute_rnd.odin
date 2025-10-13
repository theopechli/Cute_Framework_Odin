package cute_framework

import "core:c"

Rnd :: struct {
	state: [2]c.uint64_t,
}

internal_rnd_murmur3_avalanche64 :: #force_inline proc "c" (h: c.uint64_t) -> c.uint64_t {
	h := h
	h ~= h >> 33
	h *= 0xff51afd7ed558ccd
	h ~= h >> 33
	h *= 0xc4ceb9fe1a85ec53
	h ~= h >> 33
	return h
}

rnd_seed :: #force_inline proc "c" (seed: c.uint64_t) -> Rnd {
	value := internal_rnd_murmur3_avalanche64((seed << cast(c.uint64_t)1) | cast(c.uint64_t)1)
	return Rnd { state = { value, internal_rnd_murmur3_avalanche64(value) } }
}

rnd_uint64 :: #force_inline proc "c" (rnd: ^Rnd) -> c.uint64_t {
	x := rnd.state[0]
	y := rnd.state[1]
	rnd.state[0] = y
	x ~= x << 23
	x ~= x >> 17
	x ~= y ~ ( y >> 26)
	rnd.state[1] = x
	return x + y
}

rnd_float :: #force_inline proc "c" (rnd: ^Rnd) -> c.float {
	value: c.uint32_t = cast(c.uint32_t)(rnd_uint64(rnd) >> 32)

	exponent: c.uint32_t = 127
	mantissa: c.uint32_t = value >> 9
	result: c.uint32_t = (exponent << 23) | mantissa
	return (cast(^c.float)&result)^ - 1.0
}

rnd_range_int :: #force_inline proc "c" (rnd: ^Rnd, min: c.int, max: c.int) -> c.int {
	range: c.uint64_t = cast(c.uint64_t)(max - min + 1)
	value: c.int = cast(c.int)(rnd_uint64(rnd) % range)
	return min + value
}

rnd_range_float :: #force_inline proc "c" (rnd: ^Rnd, min: c.float, max: c.float) -> c.float {
	range: c.float = max - min
	value: c.float = rnd_float(rnd) * range
	return min + value
}
