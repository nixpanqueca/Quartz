# Cubic System Software - Makefile for WSL/Linux
# Uses i686-linux-gnu cross-compiler :D

CC = i686-linux-gnu-gcc
AS = nasm
LD = i686-linux-gnu-ld
OBJCOPY = i686-linux-gnu-objcopy
MKRESCUE = grub-mkrescue

CFLAGS = -ffreestanding -O2 -Wall -Wextra -nostdlib -nostdinc \
         -isystem $(shell $(CC) -print-file-name=include) \
         -Isrc/kernel \
         -fno-builtin -fno-stack-protector -nostartfiles -nodefaultlibs -m32
ASFLAGS = -f elf32
LDFLAGS = -T linker.ld -nostdlib

# Kernel source files
C_SRC = src/kernel/quartz.c src/kernel/framebuffer.c src/kernel/openfirmware.c src/kernel/keyboard.c src/kernel/prism.c src/kernel/mouse.c src/kernel/fs.c src/kernel/service.c
ASM_SRC = src/boot/boot.asm src/boot/isr.asm

# Auto-discover service .c files
SERVICE_SRC = $(shell find services -name '*.c' 2>/dev/null)

BUILD_DIR = build
OBJS = $(BUILD_DIR)/boot.o $(BUILD_DIR)/quartz.o $(BUILD_DIR)/framebuffer.o $(BUILD_DIR)/openfirmware.o $(BUILD_DIR)/keyboard.o $(BUILD_DIR)/prism.o $(BUILD_DIR)/mouse.o $(BUILD_DIR)/fs.o $(BUILD_DIR)/service.o $(BUILD_DIR)/isr.o
SERVICE_OBJS = $(patsubst services/%.c,$(BUILD_DIR)/svc_%.o,$(SERVICE_SRC))
KERNEL = $(BUILD_DIR)/quartz.elf
ISO = $(BUILD_DIR)/quartz.iso

.PHONY: all clean run iso

all: $(KERNEL)
	@echo "Build complete! :D"

iso: $(ISO)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/%.o: src/boot/%.asm | $(BUILD_DIR)
	$(AS) $(ASFLAGS) $< -o $@

$(BUILD_DIR)/%.o: src/kernel/%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/svc_%.o: services/%.c | $(BUILD_DIR)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(KERNEL): $(OBJS) $(SERVICE_OBJS) linker.ld
	$(LD) $(LDFLAGS) $(OBJS) $(SERVICE_OBJS) -o $@

# Generate grub.cfg with module lines for every file in disk/
$(BUILD_DIR)/grub.cfg: disk/*
	@echo 'set timeout=1' > $@
	@echo 'set default=0' >> $@
	@echo '' >> $@
	@echo 'menuentry "Cubic System Software" {' >> $@
	@echo '    insmod all_video' >> $@
	@echo '    set gfxpayload=keep' >> $@
	@echo '    multiboot /boot/quartz.elf' >> $@
	@cd disk && find . -type f | sort | while read f; do \
		name="$${f#./}"; \
		echo "    module /$$name $$name" >> ../$@; \
	done
	@echo '    boot' >> $@
	@echo '}' >> $@

$(ISO): $(KERNEL) $(BUILD_DIR)/grub.cfg
	mkdir -p $(BUILD_DIR)/iso/boot/grub
	cp $(KERNEL) $(BUILD_DIR)/iso/boot/quartz.elf
	cp $(BUILD_DIR)/grub.cfg $(BUILD_DIR)/iso/boot/grub/grub.cfg
	-cp -r disk/* $(BUILD_DIR)/iso/ 2>/dev/null
	$(MKRESCUE) -o $@ $(BUILD_DIR)/iso

run: $(ISO)
	qemu-system-i386 -cdrom $<

clean:
	rm -rf $(BUILD_DIR)
