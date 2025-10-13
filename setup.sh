#!/usr/bin/env bash
set -eu

export CC=gcc
export AR=ar

NPROCS=$(nproc --ignore=2)

git submodule init

OS="linux"
PROJECT_PATH=$(pwd)
LIBS_PATH="${PROJECT_PATH}/libs"
THIRD_PARTY_PATH="${PROJECT_PATH}/third_party"

mkdir -p "${LIBS_PATH}"


# Cute Framework
CUTE_FRAMEWORK_PATH="${THIRD_PARTY_PATH}/cute_framework"
CUTE_FRAMEWORK_BUILD_DIR="build"

LIBS_CUTE_FRAMEWORK_PATH="${LIBS_PATH}/cute_framework"

mkdir -p "${LIBS_CUTE_FRAMEWORK_PATH}" "${LIBS_CUTE_FRAMEWORK_PATH}/${OS}"

cd "${CUTE_FRAMEWORK_PATH}"

cmake -S . -B "${CUTE_FRAMEWORK_BUILD_DIR}" -GNinja \
      -DCMAKE_BUILD_TYPE=RelWithDebInfo \
      -DCF_FRAMEWORK_STATIC=OFF \
      -DCF_FRAMEWORK_BUILD_SAMPLES=ON \
      -DCF_FRAMEWORK_BUILD_TESTS=OFF \
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
      -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build "${CUTE_FRAMEWORK_BUILD_DIR}" -j $NPROCS

find "${CUTE_FRAMEWORK_PATH}/${CUTE_FRAMEWORK_BUILD_DIR}" -type f -regex '.*\.a$' -exec realpath {} \; | xargs -I{} cp {} "${LIBS_CUTE_FRAMEWORK_PATH}/${OS}"
find "${CUTE_FRAMEWORK_PATH}/${CUTE_FRAMEWORK_BUILD_DIR}" -type f -regex '.*\.so$' -exec realpath {} \; | xargs -I{} cp {} "${LIBS_CUTE_FRAMEWORK_PATH}/${OS}"

cd "${PROJECT_PATH}"
