@echo off
echo.
echo ========================================
echo   Cubic System Software - Build System
echo   Quartz Kernel v1.0
echo ========================================
echo.

echo Building with WSL...
wsl -- bash -c "cd /mnt/c/Users/NixPanqueca/Documents/Github/Quartz && make clean && make iso"
if %errorlevel% neq 0 (
    echo ERROR: Build failed!
    pause
    exit /b 1
)

echo.
echo ========================================
echo   BUILD SUCCESSFUL! :D
echo   ISO: build\quartz.iso
echo ========================================
echo.
echo Starting QEMU in 3 seconds...
timeout /t 3 >nul

echo Running in QEMU...
qemu-system-i386 -cdrom build\quartz.iso -display sdl,gl=off
