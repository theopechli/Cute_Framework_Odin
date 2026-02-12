#!/bin/sh
set -eu

# Static library
mkdir -p "../lib"
cc -O2 -c ckit.c
ar -rcs ../lib/ckit.a ckit.o
rm *.o

# Static library with debug symbols
# mkdir -p "../lib"
# cc -O0 -g -c ckit.c
# ar -rcs ../lib/ckit.a ckit.o
# rm *.o

# Shared library
# mkdir -p "../lib"
# cc -O2 -fPIC -c ckit.c
# cc -shared -o ../lib/libckit.so ckit.o
# rm *.o

# Shared library with debug symbols
# mkdir -p "../lib"
# cc -O0 -g -fPIC -c ckit.c
# cc -shared -o ../lib/libckit.so ckit.o
# rm *.o
