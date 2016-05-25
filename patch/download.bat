@echo off

rem echo url: %1
rem echo out: %2
rem echo sub: %3

setlocal

rem --- Redirect to download-custom.bat file if there is one
if exist "%~dp0download-custom.bat" (
    call "%~dp0download-custom.bat" %1 %2 %3
    goto :EOF
)

rem --- Download with svtplay-dl
if "%3"=="true" ( 
    set sub=--subtitle
) else (
    set sub=
)
@echo on
svtplay-dl --output %2 %sub% --remux %1
@echo off
pause