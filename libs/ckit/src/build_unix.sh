#!/bin/sh
set -eu

mkdir -p "../lib"
cc -O2 -c ckit.c
ar -rcs ../lib/ckit.a ckit.o
rm *.o
