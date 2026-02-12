@echo off
setlocal

set "PROJECT_PATH=%cd%"
set "BUILD_PATH=%PROJECT_PATH%\build"
set "LIBS_PATH=%PROJECT_PATH%\libs"
set "LIBS_CUTE_FRAMEWORK_PATH=%LIBS_PATH%\cute_framework"
set "EXE=Cute_Framework_Odin_Debug.exe"

if not exist "%BUILD_PATH%\lib" mkdir "%BUILD_PATH%\lib"

xcopy "%LIBS_CUTE_FRAMEWORK_PATH%\lib\*" "%BUILD_PATH%\lib\" /Y

odin build .\src ^
     -debug ^
     -o:none ^
     -collection:libs=.\libs ^
     -out:%BUILD_PATH%\%EXE%
