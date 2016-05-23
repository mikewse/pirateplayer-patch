@echo off
powershell -executionpolicy bypass -command "Invoke-WebRequest https://raw.githubusercontent.com/mikewse/pirateplayer-patch/master/patch/update-main.ps1 -OutFile ""%~dp0update-main.ps1"""
powershell -executionpolicy bypass -file "%~dp0update-main.ps1"
