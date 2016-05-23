@echo off
rem echo url: %1
rem echo out: %2
rem echo sub: %3
setlocal
if "%3"=="true" ( 
    set sub=--subtitle
) else (
    set sub=
)
@echo on
svtplay-dl --output %2 %sub% --remux %1
@echo off
pause