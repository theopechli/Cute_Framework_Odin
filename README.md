# Cute_Framework_Odin

[Odin](https://odin-lang.org) bindings for [Cute Framework](https://github.com/RandyGaul/cute_framework).

## Game

There is a very simple game inside the `src` folder.

### Note

In order to use [ImGui](https://github.com/ocornut/imgui), you need bindings for [dear_bindings](https://github.com/dearimgui/dear_bindings). The bindings in `./libs/imgui` are from [odin-imgui](https://gitlab.com/L-4/odin-imgui), with slight modifications, and are only there to run this game.

## Clone

To clone the repository, run:

```
git clone --recurse-submodules https://github.com/theopechli/Cute_Framework_Odin
```

If you have cloned the repository without its submodules, then go to the root of the repository and run:

```
git submodule update --init --recursive
```

## Prerequisites:

- Odin
- GCC
- CMake
- Emscripten

## Build

Execute any of the following commands from the root of the repository.

### Linux

There is a `build.sh` bash script that builds CF and the game for the desktop
and the web. Run `build.sh help` or look at the script to learn how to use it.

1. Build: `./build.sh`
1. Run: `./bin/desktop/debug/game`

## Credits

Certain parts of the game were taken from [Karl Zylinski's Odin Raylib Web template](https://github.com/karl-zylinski/odin-raylib-web), for example setting up the Emscripten allocator and logger.
