@echo off
setlocal

echo.
echo ========================================
echo   Cubic System Software - QEMU Runner
echo ========================================
echo.

if not exist "build\quartz.iso" (
    echo ERROR: ISO not found! Run build.bat first!
    pause
    exit /b 1
)

where qemu-system-i386.exe >nul 2>&1
if errorlevel 1 (
    echo ERROR: qemu-system-i386.exe is not on PATH.
    echo.
    echo Install QEMU for Windows, or just run the kernel through WSL
    echo instead: make run
    pause
    exit /b 1
)

echo Starting QEMU.
echo Press Ctrl+C to stop.
echo.
echo The kernel draws straight into VGA text mode, so there is no
echo window to click on: type commands at the Quartz^> prompt.
echo Anything the kernel prints also lands here through COM1.
echo.

qemu-system-i386 -cdrom build\quartz.iso -serial stdio