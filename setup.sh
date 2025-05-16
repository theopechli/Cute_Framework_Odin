#!/usr/bin/env bash

set -eu

export CC=gcc
export AR=ar

NPROCS=$(nproc --ignore=2)

git submodule init

PROJECT_PATH=$(pwd)
LIBS_PATH="${PROJECT_PATH}/libs"
THIRD_PARTY_PATH="${PROJECT_PATH}/third_party"

mkdir -p "${LIBS_PATH}"


# Cute Framework
CUTE_FRAMEWORK_PATH="${THIRD_PARTY_PATH}/cute_framework"
CUTE_FRAMEWORK_BUILD_DIR="build"

LIBS_CUTE_FRAMEWORK_PATH="${LIBS_PATH}/cute_framework"

mkdir -p "${LIBS_CUTE_FRAMEWORK_PATH}" "${LIBS_CUTE_FRAMEWORK_PATH}/linux"

cd "${CUTE_FRAMEWORK_PATH}"

cmake -S . -B "${CUTE_FRAMEWORK_BUILD_DIR}" -GNinja \
      -DCMAKE_BUILD_TYPE=Release \
      -DCF_FRAMEWORK_BUILD_SAMPLES=OFF \
      -DCF_FRAMEWORK_BUILD_TESTS=OFF \
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
      -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build "${CUTE_FRAMEWORK_BUILD_DIR}" -j $NPROCS

find "${THIRD_PARTY_PATH}" -type f -regex '.*\.a$' -exec realpath {} \; | xargs -I{} cp {} "${LIBS_CUTE_FRAMEWORK_PATH}/linux"

cp -f \
   "${CUTE_FRAMEWORK_PATH}/${CUTE_FRAMEWORK_BUILD_DIR}/_deps/sdl3-build/libSDL3.so" \
   "${CUTE_FRAMEWORK_PATH}/${CUTE_FRAMEWORK_BUILD_DIR}/_deps/sdl3-build/libSDL3.so.0" \
   "${CUTE_FRAMEWORK_PATH}/${CUTE_FRAMEWORK_BUILD_DIR}/_deps/sdl3-build/libSDL3.so.0.2.8" \
   "${LIBS_CUTE_FRAMEWORK_PATH}/linux"

cd "${PROJECT_PATH}"
