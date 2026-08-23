qemu-system-i386 -vga std -cdrom build\AetherSystemSoftware.iso -boot d -serial file:serial.log -monitor tcp:127.0.0.1:5572,server,nowait -no-reboot
