# Cute_Framework_Odin

[Odin](https://odin-lang.org) bindings for [Cute Framework](https://github.com/RandyGaul/cute_framework).

## Example App

There is a very simple example app inside the `src` folder.

### Note

In order to use [ImGui](https://github.com/ocornut/imgui), you need bindings for [dear_bindings](https://github.com/dearimgui/dear_bindings). The bindings in `./libs/imgui` are from [odin-imgui](https://gitlab.com/L-4/odin-imgui), with slight modifications, and are only there to run this example app.

## Clone

To clone the repository, run:

```
git clone --recurse-submodules https://github.com/theopechli/Cute_Framework_Odin
```

If you have cloned the repository without its submodules, then go to the root of the repository and run:

```
git submodule update --init --recursive
```

## Build

Execute any of the following commands from the root of the repository.

### Linux

1. Run `./setup.sh` to generate the libraries needed to build and run the above example app.
1. Run `./build_debug.sh` to build the app.
1. Run `./run_debug.sh` to run the app.

### Windows

1. Run `.\setup.bat` to generate the libraries needed to build and run the above example app.
1. Run `.\build_debug.bat` to build the app.
1. Run `.\run_debug.bat` to run the app.
