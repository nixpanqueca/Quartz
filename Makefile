# Cubic System Software - Makefile for WSL/Linux
# Uses i686-linux-gnu cross-compiler :D
#
# See README.md for the list of packages this needs.

CC = i686-linux-gnu-gcc
AS = nasm
LD = i686-linux-gnu-ld
MKRESCUE = grub-mkrescue

# -mpreferred-stack-boundary=2 tells GCC not to assume a 16 byte aligned stack:
# the boot stack and the hand built thread stacks are ours to define.
CFLAGS = -ffreestanding -O2 -Wall -Wextra -nostdlib -nostdinc \
         -isystem $(shell $(CC) -print-file-name=include) \
         -Isrc/kernel \
         -fno-builtin -fno-stack-protector -nostartfiles -nodefaultlibs -m32 \
         -fno-pic -fno-pie -mpreferred-stack-boundary=2
ASFLAGS = -f elf32
LDFLAGS = -T linker.ld -nostdlib

BUILD_DIR = build
KERNEL = $(BUILD_DIR)/quartz.elf
ISO = $(BUILD_DIR)/quartz.iso

.PHONY: all clean run iso services deps check-tools FORCE
.NOTPARALLEL:

all: check-tools $(KERNEL) services
	@echo "Build complete! :D"

iso: check-tools $(ISO)

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

# Service objects (each in its own subfolder). A pattern rule may only carry one
# %, so the stem keeps the directory: services/prismtu/prismtu.c ->
# build/svc_prismtu/prismtu.o
$(BUILD_DIR)/svc_%.o: services/%.c | $(BUILD_DIR)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

KERNEL_OBJS = $(BUILD_DIR)/boot.o $(BUILD_DIR)/isr.o \
              $(BUILD_DIR)/quartz.o $(BUILD_DIR)/console.o \
              $(BUILD_DIR)/interrupt.o $(BUILD_DIR)/timer.o \
              $(BUILD_DIR)/rtc.o $(BUILD_DIR)/mem.o \
              $(BUILD_DIR)/keyboard.o $(BUILD_DIR)/fs.o \
              $(BUILD_DIR)/thread.o $(BUILD_DIR)/service.o \
              $(BUILD_DIR)/openfirmware.o $(BUILD_DIR)/prismtu.o \
              $(BUILD_DIR)/shell.o

# services/prism/ is the graphical Prism. It stays on the boot disk as a record
# and for the framebuffer era, but it cannot be linked into a text kernel, so
# only the console service is built here.
SERVICE_OBJS = $(BUILD_DIR)/svc_prismtu/prismtu.o

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

# Regenerate grub.cfg every time: the module list depends on whatever the
# services target just copied into disk/, which make cannot express as a
# dependency, and a stale grub.cfg silently boots without its modules.
$(BUILD_DIR)/grub.cfg: FORCE services | $(BUILD_DIR)
	@echo 'set timeout=1' > $@
	@echo 'set default=0' >> $@
	@echo '' >> $@
	@echo 'menuentry "Cubic System Software" {' >> $@
	@echo '    set gfxpayload=text' >> $@
	@echo '    multiboot /boot/quartz.elf' >> $@
	@cd disk && find . -type f | sort | while read f; do \
		name="$${f#./}"; \
		echo "    module /$$name $$name" >> ../$@; \
	done
	@echo '    boot' >> $@
	@echo '}' >> $@

FORCE:

$(ISO): $(KERNEL) $(BUILD_DIR)/grub.cfg
	mkdir -p $(BUILD_DIR)/iso/boot/grub
	cp $(KERNEL) $(BUILD_DIR)/iso/boot/quartz.elf
	cp $(BUILD_DIR)/grub.cfg $(BUILD_DIR)/iso/boot/grub/grub.cfg
	-cp -r disk/* $(BUILD_DIR)/iso/ 2>/dev/null
	$(MKRESCUE) -o $@ $(BUILD_DIR)/iso

run: $(ISO)
	qemu-system-i386 -cdrom $< -serial stdio

clean:
	rm -rf $(BUILD_DIR)

# Prints the packages this needs and whether they are actually installed.
deps:
	@echo "Quartz build dependencies (Debian/Ubuntu, inside WSL):"
	@echo ""
	@echo "  sudo apt update"
	@echo "  sudo apt install gcc-i686-linux-gnu binutils-i686-linux-gnu nasm \\"
	@echo "                       grub-pc-bin xorriso mtools qemu-system-x86"
	@echo ""
	@echo "Checking this machine:"
	@for tool in $(CC) $(AS) $(LD) grub-mkrescue xorriso qemu-system-i386 make; do \
		if command -v $$tool >/dev/null 2>&1; then \
			echo "  [ok]      $$tool -> $$(command -v $$tool)"; \
		else \
			echo "  [MISSING] $$tool"; \
		fi; \
	done
	@echo ""
	@if command -v $(CC) >/dev/null 2>&1; then \
		echo "Compiler include path used by CFLAGS:"; \
		echo "  $$($(CC) -print-file-name=include)"; \
	else \
		echo "Nothing to show: $(CC) is not installed."; \
	fi

# Guard so a missing compiler fails with instructions instead of "Error 127".
# Runs before anything is compiled.
check-tools:
	@missing=0; \
	for tool in $(CC) $(LD) $(AS); do \
		if ! command -v $$tool >/dev/null 2>&1; then \
			echo "ERROR: $$tool is not installed."; \
			missing=1; \
		fi; \
	done; \
	if [ $$missing -ne 0 ]; then \
		echo ""; \
		echo "Quartz needs the i686 cross toolchain, not just -m32 support:"; \
		echo ""; \
		echo "  sudo apt update"; \
		echo "  sudo apt install gcc-i686-linux-gnu binutils-i686-linux-gnu"; \
		echo ""; \
		echo "Then run 'make deps' again to confirm."; \
		exit 1; \
	fi