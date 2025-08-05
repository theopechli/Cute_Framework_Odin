@echo off
setlocal

set "PROJECT_PATH=%cd%"
set "BUILD_PATH=%PROJECT_PATH%\build\windows"
set "EXE=Cute_Framework_Odin_Debug.exe"

pushd "%BUILD_PATH%"
"%EXE%"
popd
