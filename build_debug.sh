#!/usr/bin/env bash
set -eu

OS="linux"
PROJECT_PATH=$(pwd)
BUILD_PATH="${PROJECT_PATH}/build"
LIBS_PATH="${PROJECT_PATH}/libs"
LIBS_CUTE_FRAMEWORK_PATH="${LIBS_PATH}/cute_framework"
EXE="Cute_Framework_Odin_Debug.bin"

mkdir -p "${BUILD_PATH}" "${BUILD_PATH}/${OS}"

cp -r "${LIBS_CUTE_FRAMEWORK_PATH}/${OS}/"*.so "${BUILD_PATH}/${OS}"

EXTRA_LINKER_FLAGS="'-Wl,-rpath=\$ORIGIN/${OS}'"

odin build ./src \
     -vet \
     -strict-style \
     -debug \
     -o:none \
     -collection:libs=./libs \
     -extra-linker-flags:"${EXTRA_LINKER_FLAGS}" \
     -out:"${BUILD_PATH}/${EXE}"
