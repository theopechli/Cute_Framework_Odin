@echo off

REM Static library
if not exist "..\lib" mkdir ..\lib
cl -nologo -MT -TC /std:clatest /experimental:c11atomics -O2 -c ckit.c
lib -nologo ckit.obj -out:..\lib\ckit.lib
del *.obj

REM Static library with debug symbols
REM if not exist "..\lib" mkdir ..\lib
REM cl -nologo -MTd -TC -Z7 -Od -c ckit.c
REM lib -nologo ckit.obj -out:..\lib\ckit.lib
REM del *.obj

REM Shared library
REM if not exist "..\lib" mkdir ..\lib
REM cl -nologo -MT -TC -O2 -c ckit.c
REM link -nologo -dll -out:..\lib\ckit.dll ckit.obj
REM del *.obj

REM Shared library with debug symbols
REM if not exist "..\lib" mkdir ..\lib
REM cl -nologo -MTd -TC -Z7 -Od -c ckit.c
REM link -nologo -dll -out:..\lib\ckit.dll ckit.obj
REM del *.obj
