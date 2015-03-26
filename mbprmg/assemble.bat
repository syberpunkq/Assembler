@echo off
if not exist rsrc.rc goto over1
"c:\masm32\bin\rc.exe" /v rsrc.rc
"c:\masm32\bin\cvtres" /machine:ix86 rsrc.res
:over1
if exist *.obj del *.obj
if exist *.exe del *.exe
"c:\masm32\bin\ml.exe" /c /coff *.asm
if errorlevel 1 goto TheEnd
if not exist rsrc.obj goto nores
"c:\masm32\bin\Link.exe" /SUBSYSTEM:WINDOWS *.obj rsrc.obj
if errorlevel 1 goto TheEnd
dir *.*
goto TheEnd
:nores
"c:\masm32\bin\Link.exe" /SUBSYSTEM:WINDOWS *.obj
if errorlevel 1 goto TheEnd
dir *.*
goto TheEnd
:TheEnd
