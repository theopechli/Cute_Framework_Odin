#!/usr/bin/env bash
set -eu

PROJECT_PATH=$(pwd)
BUILD_PATH="${PROJECT_PATH}/build"
EXE="Cute_Framework_Odin_Debug.bin"

(
cd "${BUILD_PATH}"
"./${EXE}"
)
