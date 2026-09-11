# Cubic System Software - CMake Build Configuration
# For building our Quartz kernel! :D

cmake_minimum_required(VERSION 3.10)
project(CubicSystemSoftware VERSION 1.0.0 LANGUAGES C ASM)

# Set cross-compilation flags
# You'll need to install i686-elf-gcc first!
set(CMAKE_C_COMPILER i686-elf-gcc)
set(CMAKE_ASM_COMPILER i686-elf-gcc)
set(CMAKE_C_COMPILER_WORKS 1)
set(CMAKE_ASM_COMPILER_WORKS 1)

# Compiler flags for OS development
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -ffreestanding -O2 -Wall -Wextra -nostdlib -nostdinc -fno-builtin -fno-stack-protector -nostartfiles -nodefaultlibs")
set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} -ffreestanding -O2")

# Linker flags
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -T ${CMAKE_SOURCE_DIR}/linker.ld -ffreestanding -O2 -nostdlib -nostartfiles -nodefaultlibs")

# Source files
set(KERNEL_SOURCES
    src/kernel/quartz.c
    src/kernel/framebuffer.c
    src/kernel/openfirmware.c
)

# Assembly source
set(ASM_SOURCES
    src/boot/boot.asm
)

# Create kernel executable
add_executable(quartz.elf
    ${KERNEL_SOURCES}
    ${ASM_SOURCES}
)

# Set output directory
set_target_properties(quartz.elf PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
)

# Custom target to create bootable ISO
add_custom_target(iso
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/iso/boot/grub
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_BINARY_DIR}/bin/quartz.elf ${CMAKE_BINARY_DIR}/iso/boot/quartz.elf
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/grub/grub.cfg ${CMAKE_BINARY_DIR}/iso/boot/grub/grub.cfg
    COMMAND grub-mkrescue -o ${CMAKE_BINARY_DIR}/quartz.iso ${CMAKE_BINARY_DIR}/iso
    COMMENT "Creating bootable ISO with GRUB... :D"
)

# Clean target
add_custom_target(clean-all
    COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_BINARY_DIR}
    COMMENT "Cleaning everything! >:3"
)
