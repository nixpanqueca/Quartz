@echo off
powershell -ExecutionPolicy Bypass -File "%~dp0\tools\convert_bmps.ps1" -Dir "%~dp0\assets\sprites"
pause
