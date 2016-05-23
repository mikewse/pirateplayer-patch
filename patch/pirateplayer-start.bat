@echo off
if "%1"=="" (
    start /min cmd /c %0 run
) else (
    cd "%~p0"
    powershell -executionpolicy bypass -file backend-server.ps1 start
    start /wait ..\pirateplayer
    powershell -executionpolicy bypass -file backend-server.ps1 stop
)
