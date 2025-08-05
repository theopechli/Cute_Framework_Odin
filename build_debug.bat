@echo off
setlocal

set "PROJECT_PATH=%cd%"
set "BUILD_PATH=%PROJECT_PATH%\build\windows"
set "LIBS_PATH=%PROJECT_PATH%\libs"
set "LIBS_CUTE_FRAMEWORK_PATH=%LIBS_PATH%\cute_framework"
set "EXE=Cute_Framework_Odin_Debug.exe"

if not exist "%BUILD_PATH%" mkdir "%BUILD_PATH%"

xcopy "%LIBS_CUTE_FRAMEWORK_PATH%\windows\*.dll" "%BUILD_PATH%\" /Y

odin build .\src ^
     -vet ^
     -strict-style ^
     -debug ^
     -o:none ^
     -collection:libs=.\libs ^
     -out:%BUILD_PATH%\%EXE%
