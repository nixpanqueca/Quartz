#!/usr/bin/env bash
# Cubic System Software - Build script for native Linux
# Equivalent to build.bat, but without the WSL indirection: the Makefile
# already runs under Linux, so this just drives `make` directly.

set -u

echo
echo "========================================"
echo "  Cubic System Software - Build System"
echo "  Quartz Kernel - text mode"
echo "========================================"
echo

if ! command -v make >/dev/null 2>&1; then
    echo "ERROR: 'make' is not installed."
    echo "Install it with: sudo apt install make"
    exit 1
fi

echo "Repository: $(pwd)"
echo
echo "Checking dependencies..."
echo

# `make deps` only reports what is missing, it never installs anything.
make deps
echo

if ! make iso; then
    echo
    echo "========================================"
    echo "  BUILD FAILED"
    echo "========================================"
    echo
    echo "Run 'make deps' and install whatever it reports as MISSING,"
    echo "then try again."
    exit 1
fi

echo
echo "========================================"
echo "  BUILD SUCCESSFUL! :D"
echo "  ISO: build/quartz.iso"
echo "========================================"
echo
echo "Booting QEMU in 3 seconds. Press Ctrl+C to stop."
echo

sleep 3

if command -v qemu-system-i386 >/dev/null 2>&1; then
    qemu-system-i386 -cdrom build/quartz.iso -serial stdio
else
    echo "ERROR: qemu-system-i386 is not on PATH."
    echo
    echo "Install QEMU with: sudo apt install qemu-system-x86"
    echo "Then run the kernel manually with: make run"
    exit 1
fi
