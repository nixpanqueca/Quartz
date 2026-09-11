@echo off
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

echo Starting QEMU...
echo Press Ctrl+C to stop
echo.

qemu-system-i386 -cdrom build\quartz.iso -display sdl,gl=off
