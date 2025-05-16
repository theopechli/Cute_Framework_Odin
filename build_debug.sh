#!/usr/bin/env bash

mkdir -p ./build/

odin build ./src \
     -vet \
     -strict-style \
     -debug \
     -o:none \
     -collection:libs=libs \
     -out:./build/Cute_Framework_Odin_Debug.bin
