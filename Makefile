# Cubic System Software - Makefile for WSL/Linux
# Uses i686-linux-gnu cross-compiler :D

CC = i686-linux-gnu-gcc
AS = nasm
LD = i686-linux-gnu-ld
MKRESCUE = grub-mkrescue

CFLAGS = -ffreestanding -O2 -Wall -Wextra -nostdlib -nostdinc \
         -isystem $(shell $(CC) -print-file-name=include) \
         -Isrc/kernel \
         -fno-builtin -fno-stack-protector -nostartfiles -nodefaultlibs -m32 \
         -fno-pic -fno-pie
ASFLAGS = -f elf32
LDFLAGS = -T linker.ld -nostdlib

BUILD_DIR = build
KERNEL = $(BUILD_DIR)/quartz.elf
ISO = $(BUILD_DIR)/quartz.iso

.PHONY: all clean run iso services

all: $(KERNEL) services
	@echo "Build complete! :D"

iso: $(ISO) services

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Boot assembly
$(BUILD_DIR)/boot.o: src/boot/boot.asm | $(BUILD_DIR)
	$(AS) $(ASFLAGS) $< -o $@

$(BUILD_DIR)/isr.o: src/boot/isr.asm | $(BUILD_DIR)
	$(AS) $(ASFLAGS) $< -o $@

# Kernel C sources
$(BUILD_DIR)/%.o: src/kernel/%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Service objects (each in own subfolder)
$(BUILD_DIR)/svc_prism/prism.o: services/prism/prism.c | $(BUILD_DIR)
	@mkdir -p $(BUILD_DIR)/svc_prism
	$(CC) $(CFLAGS) -c $< -o $@

KERNEL_OBJS = $(BUILD_DIR)/boot.o $(BUILD_DIR)/isr.o \
              $(BUILD_DIR)/quartz.o $(BUILD_DIR)/framebuffer.o \
              $(BUILD_DIR)/openfirmware.o $(BUILD_DIR)/keyboard.o \
              $(BUILD_DIR)/prism.o $(BUILD_DIR)/mouse.o \
              $(BUILD_DIR)/fs.o $(BUILD_DIR)/service.o \
              $(BUILD_DIR)/thread.o

SERVICE_OBJS = $(BUILD_DIR)/svc_prism/prism.o

$(KERNEL): $(KERNEL_OBJS) $(SERVICE_OBJS) linker.ld
	$(LD) $(LDFLAGS) $(KERNEL_OBJS) $(SERVICE_OBJS) -o $@

# Copy service source files to disk/ as .app or .service
services:
	@for svc_dir in services/*/; do \
		[ -d "$$svc_dir" ] || continue; \
		name=$$(basename $$svc_dir); \
		svc_c="$${svc_dir}$${name}.c"; \
		manifest="$${svc_dir}manifest.txt"; \
		[ -f "$$svc_c" ] || continue; \
		type=$$(grep '^type=' "$$manifest" 2>/dev/null | cut -d= -f2 | tr -d ' \r\n'); \
		[ -z "$$type" ] && type=service; \
		if [ "$$type" = "app" ]; then ext="app"; else ext="service"; fi; \
		disk_path=$$(grep '^path=' "$$manifest" 2>/dev/null | cut -d= -f2 | tr -d ' \r\n'); \
		[ -z "$$disk_path" ] && disk_path="/system/compiled/$$name"; \
		disk_file="disk$$disk_path.$$ext"; \
		mkdir -p "disk$$(dirname $$disk_path)"; \
		cp "$$svc_c" "$$disk_file"; \
		echo "  -> $$disk_file"; \
	done

# Generate grub.cfg with module lines for every file in disk/
$(BUILD_DIR)/grub.cfg: disk/* services
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
