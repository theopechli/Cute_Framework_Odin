@echo off

if not exist "..\lib" mkdir ..\lib

cl -nologo -MT -TC -O2 -c ckit.c
lib -nologo ckit.obj -out:..\lib\ckit.lib

del *.obj
