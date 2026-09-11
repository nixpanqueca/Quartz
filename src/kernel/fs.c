/* Cubic System Software - Filesystem (multiboot modules) */

#include "fs.h"
#include "framebuffer.h"
#include <stdint.h>

#define MAX_MODULES 32

static fs_file_t files[MAX_MODULES];
static int file_count = 0;

#define MB_FLAG_MODS (1 << 3)

typedef struct {
    uint32_t mod_start;
    uint32_t mod_end;
    uint32_t cmdline;
    uint32_t pad;
} __attribute__((packed)) multiboot_mod_t;

typedef struct {
    uint32_t flags;
    uint32_t mem_lower;
    uint32_t mem_upper;
    uint32_t boot_device;
    uint32_t cmdline;
    uint32_t mods_count;
    uint32_t mods_addr;
    uint32_t syms[4];
    uint32_t mmap_length;
    uint32_t mmap_addr;
    uint32_t drives_length;
    uint32_t drives_addr;
    uint32_t config_table;
    uint32_t boot_loader_name;
    uint32_t apm_table;
    uint32_t vbe_control_info;
    uint32_t vbe_mode_info;
    uint16_t vbe_mode;
    uint16_t vbe_interface_seg;
    uint16_t vbe_interface_off;
    uint16_t vbe_interface_len;
    uint64_t framebuffer_addr;
    uint32_t framebuffer_pitch;
    uint32_t framebuffer_width;
    uint32_t framebuffer_height;
    uint8_t  framebuffer_bpp;
    uint8_t  framebuffer_type;
} __attribute__((packed)) multiboot_info_t;

static void outb(uint16_t port, uint8_t val) {
    __asm__ __volatile__("outb %0, %1" : : "a"(val), "Nd"(port));
}

static uint8_t inb(uint16_t port) {
    uint8_t ret;
    __asm__ __volatile__("inb %1, %0" : "=a"(ret) : "Nd"(port));
    return ret;
}

static void dbg(char c) {
    while (!(inb(0x3F8 + 5) & 0x20));
    outb(0x3F8, c);
}

static void dbg_str(const char* s) {
    for (int i = 0; s[i]; i++) dbg(s[i]);
}

void fs_init(uint32_t mb_info_addr) {
    multiboot_info_t* mb = (multiboot_info_t*)mb_info_addr;

    dbg_str("[FS] init\n");

    if (!(mb->flags & MB_FLAG_MODS)) {
        dbg_str("[FS] no modules\n");
        return;
    }

    uint32_t count = mb->mods_count;
    multiboot_mod_t* mods = (multiboot_mod_t*)(uint32_t)mb->mods_addr;

    if (count > MAX_MODULES) count = MAX_MODULES;
    file_count = (int)count;

    for (int i = 0; i < file_count; i++) {
        files[i].mod_start = mods[i].mod_start;
        files[i].mod_end = mods[i].mod_end;
        files[i].name = (const char*)(uint32_t)mods[i].cmdline;

        dbg_str("[FS] "); dbg_str(files[i].name); dbg('\n');
    }

    dbg_str("[FS] ");
    dbg('0' + file_count);
    dbg_str(" files loaded\n");
}

int fs_file_count(void) {
    return file_count;
}

const fs_file_t* fs_get_file(int index) {
    if (index < 0 || index >= file_count) return 0;
    return &files[index];
}

const fs_file_t* fs_find(const char* name) {
    if (*name == '/') name++;
    for (int i = 0; i < file_count; i++) {
        const char* a = files[i].name;
        const char* b = name;
        while (*a && *b && *a == *b) { a++; b++; }
        if (*a == *b) return &files[i];
    }
    return 0;
}
