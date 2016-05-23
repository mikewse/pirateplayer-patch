@echo off
powershell -executionpolicy bypass -command "(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/mikewse/pirateplayer-patch/master/patch/update-main.ps1', '%~dp0update-main.ps1')"
powershell -executionpolicy bypass -file "%~dp0update-main.ps1"
