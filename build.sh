#!/usr/bin/env bash

# Usage: ./build.sh [desktop|web] [debug|release] [lld|mold] [setup] [clean]
#
# | Command                 | Description                                      |
# |-------------------------+--------------------------------------------------|
# | ./build.sh              | desktop, debug                                   |
# | ./build.sh release      | desktop, release                                 |
# | ./build.sh web          | web, debug                                       |
# | ./build.sh web release  | web, release                                     |
# | ./build.sh release mold | desktop release, linked with mold (desktop only) |
# | ./build.sh setup        | build Cute Framework                             |
# | ./build.sh clean        | clean build Cute Framework                       |
#
# Cute Framework is built automatically the first time its libraries are
# missing. Libraries go to
# bindings/cute_framework/lib/<desktop|web>/<debug|release>/. Output goes to
# bin/<desktop|web>/<debug|release>/.

set -euo pipefail
[[ -n "${TRACE:-}" ]] && set -x # TRACE=1 ./build.sh to see every command

cd "$(dirname "$0")"

################################################################################
# Config

cf_src="third_party/cute_framework"
asyncify_remove="$cf_src/cmake/asyncify_remove.txt"
cores=$(nproc --ignore=2)

################################################################################
# Arguments

platform=desktop
mode=debug
linker=lld
setup=false
clean=false

usage() { sed -n '/^# Usage/,/^$/p' "$0" | sed 's/^# \{0,1\}//'; }
die()   { echo "error: $*" >&2; exit 1; }

for arg in "$@"; do
	case "$arg" in
		desktop|web)    platform="$arg" ;;
		debug|release)  mode="$arg" ;;
		lld|mold)       linker="$arg" ;;
		setup)          setup=true ;;
		clean)          setup=true; clean=true ;;
		-h|--help|help) usage; exit 0 ;;
		*)              usage; die "unknown argument '$arg'" ;;
	esac
done

cf_build="$cf_src/build/$platform/$mode"
cf_libs="bindings/cute_framework/lib/$platform/$mode"
out="bin/$platform/$mode"

echo "build mode: $platform / $mode"

################################################################################
# Cute Framework

build_cf() {
	if [[ "$platform" == web ]]; then
		command -v emcmake >/dev/null || die "emcmake not found, run 'source emsdk_env.sh'"
	fi

	git submodule update --init --recursive "$cf_src"

	if command -v ccache >/dev/null; then
		export CMAKE_C_COMPILER_LAUNCHER=ccache CMAKE_CXX_COMPILER_LAUNCHER=ccache
	fi

	local cmake_type=Release static=ON
	if [[ "$mode" == debug ]]; then cmake_type=Debug; fi
	if [[ "$platform" == desktop && "$mode" == debug ]]; then static=OFF; fi

	local cmake=(cmake)
	local flags=(
		-G Ninja
		-DCMAKE_BUILD_TYPE="$cmake_type"
		-DCF_FRAMEWORK_STATIC="$static"
		-DCF_FRAMEWORK_BUILD_SAMPLES=OFF
		-DCF_FRAMEWORK_BUILD_TESTS=OFF
		-DCF_USE_SYSTEM_SDL=OFF
	)

	if [[ "$platform" == web ]]; then
		cmake=(emcmake cmake)
	else
		export CC=gcc CXX=g++
		flags+=(-DCMAKE_LINKER_TYPE="${linker^^}")
	fi

	if [[ "$clean" == true ]]; then rm -rf "$cf_build"; fi

	"${cmake[@]}" -S "$cf_src" -B "$cf_build" "${flags[@]}"
	cmake --build "$cf_build" -j"$cores"

	mkdir -p "$cf_libs"
	cp -u "$cf_build/lib/"* "$cf_libs/"
}

################################################################################
# Odin Flags

odin_flags=(
	-thread-count:"$cores"
	-show-timings
	-collection:cf=bindings
)

if [[ "$mode" == debug ]]; then
	odin_flags+=(-debug)
else
	odin_flags+=(
		-o:speed -no-bounds-check
		-warnings-as-errors -disallow-do
		-strict-style -vet -vet-cast -vet-tabs -vet-using-param
	)
fi

################################################################################
# Desktop Build

build_desktop() {
	local flags=(-linker:"$linker" -out:"$out/game")

	if [[ "$mode" == debug ]]; then
		cp -u "$cf_libs/"*.so* "$out/"
	fi

	odin build src/main_desktop "${odin_flags[@]}" "${flags[@]}"
	echo "Run: $out/game"
}

################################################################################
# Web Build

build_web() {
	command -v em++ >/dev/null || die "em++ not found, run 'source emsdk_env.sh'"

	local libs=("$cf_libs/libcute.a" "$cf_libs/libphysfs.a")
	for lib in "${libs[@]}"; do
		[[ -f "$lib" ]] || die "missing $lib (run './build.sh web $mode setup')"
	done

	local comp_opt=()
	local link_opt=()
	if [[ "$mode" == debug ]]; then
		comp_opt=(-O0 -g)
		link_opt=(-sASSERTIONS=1)
	else
		comp_opt=(-O2)
	fi

	odin build src/main_web "${odin_flags[@]}" \
		-target:js_wasm32 \
		-build-mode:obj \
		-out:"$out/game.wasm.o" \
		-define:CF_WASM_LIB=env.o \
		-define:FS_WASM_LIB=env.o

	emcc -c bindings/fs/src/fs.c -o "$out/fs.o" "${comp_opt[@]}"

	em++ -o "$out/index.html" \
		"$out/game.wasm.o" "$out/fs.o" "${libs[@]}" \
		"${comp_opt[@]}" \
		"${link_opt[@]}" \
		-lidbfs.js \
		-sUSE_SDL=3 \
		-sUSE_WEBGL2=1 -sMIN_WEBGL_VERSION=2 -sMAX_WEBGL_VERSION=2 -sFULL_ES3=1 \
		-sALLOW_MEMORY_GROWTH=1 \
		-sFILESYSTEM=1 \
		-sASYNCIFY=1 -sASYNCIFY_STACK_SIZE=2040000 \
		-sASYNCIFY_REMOVE=@"$asyncify_remove" \
		-sWARN_ON_UNDEFINED_SYMBOLS=0 \
		--preload-file content \
		--shell-file src/main_web/index.html

	rm -f "$out/game.wasm.o" "$out/fs.o"

	cp -u "$(odin root)/core/sys/wasm/js/odin.js" "$out/"
	cp -u src/main_web/main.css src/main_web/main.js src/main_web/logo.svg "$out/"

	echo "Run: emrun --no_browser --port 8000 $out/index.html"
}

################################################################################
# Build

if [[ "$setup" == true || ! -d "$cf_libs" ]]; then
	build_cf
fi

mkdir -p "$out"
"build_$platform"
