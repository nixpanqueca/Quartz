@echo off
setlocal

echo.
echo ========================================
echo   Cubic System Software - Build System
echo   Quartz Kernel - text mode
echo ========================================
echo.

rem --- WSL has to be there, the Makefile only runs under Linux ---

where wsl.exe >nul 2>&1
if errorlevel 1 (
    echo ERROR: WSL is not installed.
    echo.
    echo From an Administrator prompt:
    echo     wsl --install -d Ubuntu
    echo.
    echo Then reboot Windows and run build.bat again.
    pause
    exit /b 1
)

rem --- Translate the current directory into something WSL understands, which
rem --- also proves a distribution is actually registered ---

set "WSLPATH="
for /f "usebackq delims=" %%i in (`wsl wslpath -a "%CD%" 2^>nul`) do set "WSLPATH=%%i"

if not defined WSLPATH (
    echo ERROR: WSL is installed but no Linux distribution answers.
    echo.
    echo From an Administrator prompt:
    echo     wsl --install -d Ubuntu
    echo.
    echo Or, if a distribution is installed but this is the first run:
    echo     wsl --set-default Ubuntu
    pause
    exit /b 1
)

echo Repository inside WSL: %WSLPATH%
echo.
echo Checking dependencies...
echo.

rem `make deps` only lists what is missing, it never installs anything.
wsl -- bash -c "cd '%WSLPATH%' && make deps"
echo.

wsl -- bash -c "cd '%WSLPATH%' && make iso"
if errorlevel 1 (
    echo.
    echo ========================================
    echo   BUILD FAILED
    echo ========================================
    echo.
    echo Run "make deps" inside WSL and install whatever it reports as
    echo MISSING, then try again.
    pause
    exit /b 1
)

echo.
echo ========================================
echo   BUILD SUCCESSFUL! :D
echo   ISO: build\quartz.iso
echo ========================================
echo.
echo Booting QEMU in 3 seconds. Press Ctrl+C to stop.
echo.

timeout /t 3 >nul
qemu-system-i386 -cdrom build\quartz.iso -serial stdio