@echo off
powershell -executionpolicy bypass -command "Invoke-WebRequest https://raw.githubusercontent.com/mikewse/pirateplayer/master/LICENSE -OutFile ""%~dp0LICENSE"""
powershell -executionpolicy bypass -file "%~dp0update-main.ps1"
