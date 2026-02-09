#!/usr/bin/env bash
set -eu

PROJECT_PATH=$(pwd)
BUILD_PATH="${PROJECT_PATH}/build"
LIBS_PATH="${PROJECT_PATH}/libs"
LIBS_CUTE_FRAMEWORK_PATH="${LIBS_PATH}/cute_framework"
EXE="Cute_Framework_Odin_Debug.bin"

mkdir -p "${BUILD_PATH}" "${BUILD_PATH}/lib"

cp -r "${LIBS_CUTE_FRAMEWORK_PATH}/lib/"*.so* "${BUILD_PATH}/lib/"

EXTRA_LINKER_FLAGS="'-Wl,-rpath=\$ORIGIN/lib'"

odin build ./src \
     -debug \
     -o:none \
     -collection:libs=./libs \
     -extra-linker-flags:"${EXTRA_LINKER_FLAGS}" \
     -out:"${BUILD_PATH}/${EXE}"
