# Cute_Framework_Odin

[Odin](https://odin-lang.org) bindings for [Cute Framework](https://github.com/RandyGaul/cute_framework).

## Example

There is a very simple example inside the `src` folder.

### Note

In order to use [ImGui](https://github.com/ocornut/imgui), you need bindings for [cimgui](https://github.com/cimgui/cimgui). The bindings in `./libs/cimgui` are there only to run this example.

Read more at [Cute Framework's documentation](https://randygaul.github.io/cute_framework/#/topics/dear_imgui).

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

1. Run `./setup.sh`, which will generate the libraries needed to build and run the above example.
1. Build with `./build_debug.sh`.
1. Run with `./run_debug.sh`.
