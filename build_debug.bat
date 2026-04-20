@echo off
setlocal

set "PROJECT_PATH=%cd%"
set "BUILD_PATH=%PROJECT_PATH%\build"
set "LIBS_PATH=%PROJECT_PATH%\libs"
set "LIBS_CUTE_FRAMEWORK_PATH=%LIBS_PATH%\cute_framework"
set "EXE=Cute_Framework_Odin_Debug.exe"

xcopy "%LIBS_CUTE_FRAMEWORK_PATH%\lib\*" "%BUILD_PATH%\" /Y

odin build .\src ^
     -debug ^
     -o:none ^
     -collection:libs=.\libs ^
     -out:%BUILD_PATH%\%EXE%
