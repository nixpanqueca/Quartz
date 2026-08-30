@echo off

echo Aether System Software build tool
taskkill /IM qemu-system-i386.exe /F >nul 2>&1
if not exist build mkdir build

echo Assembling boot...
nasm boot\boot.asm -f bin -o build\boot.bin
nasm boot\mbr.asm -f bin -o build\mbr.bin
nasm boot\startup.asm -f elf32 -o build\startup.o

echo Compiling Pascal kernel...
fpc -Sg -al kernel\quartz.pas
fpc -Sg -al kernel\video.pas
fpc -Sg -al kernel\serial.pas
fpc -Sg -al kernel\mouse.pas
fpc -Sg -al kernel\buttons.pas
fpc -Sg -al kernel\prism.pas
fpc -Sg -al kernel\cdrom.pas
fpc -Sg -al kernel\bmp.pas
fpc -Sg -al kernel\keyboard.pas
fpc -Sg -al kernel\openfirmware.pas
fpc -Sg -al kernel\openshell.pas
fpc -Sg -al kernel\windows.pas
fpc -Sg -al kernel\svc.pas
move /Y kernel\serial.o build\serial.o >nul
move /Y kernel\video.o build\video.o >nul
move /Y kernel\mouse.o build\mouse.o >nul
move /Y kernel\buttons.o build\buttons.o >nul
move /Y kernel\prism.o build\prism.o >nul
move /Y kernel\cdrom.o build\cdrom.o >nul
move /Y kernel\bmp.o build\bmp.o >nul
move /Y kernel\quartz.o build\quartz.o >nul
move /Y kernel\keyboard.o build\keyboard.o >nul
move /Y kernel\openfirmware.o build\openfirmware.o >nul
move /Y kernel\openshell.o build\openshell.o >nul
move /Y kernel\windows.o build\windows.o >nul
move /Y kernel\svc.o build\svc.o >nul

echo Converting FPC COFF objects to ELF32...
i386-elf-objcopy -O elf32-i386 --input-target=coff-i386 build\quartz.o build\quartz_elf.o
i386-elf-objcopy -O elf32-i386 --input-target=coff-i386 build\video.o build\video_elf.o
i386-elf-objcopy -O elf32-i386 --input-target=coff-i386 build\serial.o build\serial_elf.o
i386-elf-objcopy -O elf32-i386 --input-target=coff-i386 build\mouse.o build\mouse_elf.o
i386-elf-objcopy -O elf32-i386 --input-target=coff-i386 build\buttons.o build\buttons_elf.o
i386-elf-objcopy -O elf32-i386 --input-target=coff-i386 build\prism.o build\prism_elf.o
i386-elf-objcopy -O elf32-i386 --input-target=coff-i386 build\cdrom.o build\cdrom_elf.o
i386-elf-objcopy -O elf32-i386 --input-target=coff-i386 build\bmp.o build\bmp_elf.o
i386-elf-objcopy -O elf32-i386 --input-target=coff-i386 build\keyboard.o build\keyboard_elf.o
i386-elf-objcopy -O elf32-i386 --input-target=coff-i386 build\openfirmware.o build\openfirmware_elf.o
i386-elf-objcopy -O elf32-i386 --input-target=coff-i386 build\openshell.o build\openshell_elf.o
i386-elf-objcopy -O elf32-i386 --input-target=coff-i386 build\windows.o build\windows_elf.o
i386-elf-objcopy -O elf32-i386 --input-target=coff-i386 build\svc.o build\svc_elf.o

echo Fixing PC-relative relocations...
powershell -ExecutionPolicy Bypass -File tools\fixrelocs.ps1 -Path build\quartz_elf.o
powershell -ExecutionPolicy Bypass -File tools\fixrelocs.ps1 -Path build\video_elf.o
powershell -ExecutionPolicy Bypass -File tools\fixrelocs.ps1 -Path build\serial_elf.o
powershell -ExecutionPolicy Bypass -File tools\fixrelocs.ps1 -Path build\mouse_elf.o
powershell -ExecutionPolicy Bypass -File tools\fixrelocs.ps1 -Path build\buttons_elf.o
powershell -ExecutionPolicy Bypass -File tools\fixrelocs.ps1 -Path build\prism_elf.o
powershell -ExecutionPolicy Bypass -File tools\fixrelocs.ps1 -Path build\cdrom_elf.o
powershell -ExecutionPolicy Bypass -File tools\fixrelocs.ps1 -Path build\bmp_elf.o
powershell -ExecutionPolicy Bypass -File tools\fixrelocs.ps1 -Path build\keyboard_elf.o
powershell -ExecutionPolicy Bypass -File tools\fixrelocs.ps1 -Path build\openfirmware_elf.o
powershell -ExecutionPolicy Bypass -File tools\fixrelocs.ps1 -Path build\openshell_elf.o
powershell -ExecutionPolicy Bypass -File tools\fixrelocs.ps1 -Path build\windows_elf.o
powershell -ExecutionPolicy Bypass -File tools\fixrelocs.ps1 -Path build\svc_elf.o

echo Linking kernel...
i386-elf-ld ^
 -T linker.ld ^
 build\startup.o ^
 build\quartz_elf.o ^
 build\video_elf.o ^
 build\serial_elf.o ^
 build\mouse_elf.o ^
 build\buttons_elf.o ^
 build\prism_elf.o ^
 build\cdrom_elf.o ^
 build\bmp_elf.o ^
 build\keyboard_elf.o ^
 build\openfirmware_elf.o ^
 build\openshell_elf.o ^
 build\windows_elf.o ^
 build\svc_elf.o ^
 -o build\quartz.bin

echo Converting to raw binary...
i386-elf-objcopy -O binary build\quartz.bin build\quartz.flat

echo Compiling Aether programs...
powershell -ExecutionPolicy Bypass -File tools\build_programs.ps1

echo Creating CD-ROM image (ISO 9660 + El Torito)...
powershell -ExecutionPolicy Bypass -File tools\make_iso.ps1

echo Output image: build\AetherSystemSoftware.iso
echo.

echo Launching QEMU...
call run.bat
