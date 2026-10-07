/* Cubic System Software - Multiboot structures */
/* One copy of the GRUB handover format instead of three. */

#ifndef MULTIBOOT_H
#define MULTIBOOT_H

#include <stdint.h>

#define MULTIBOOT_MAGIC             0x2BADB002u
#define MULTIBOOT_BOOTLOADER_MAGIC  0x36D76289u

/* Bits in multiboot_info_t.flags */
#define MB_ALIGN    (1u << 0)
#define MB_MEMINFO  (1u << 1)
#define MB_VIDEO    (1u << 2)
#define MB_MODS     (1u << 3)
#define MB_MMAP     (1u << 6)
#define MB_CMDLINE  (1u << 16)

/* Values for the video mode request in the multiboot header */
#define MB_VIDEO_TEXT     0
#define MB_VIDEO_GRAPHICS 1

typedef struct {
    uint32_t flags;
    uint32_t mem_lower;          /* KiB below 1MB */
    uint32_t mem_upper;          /* KiB above 1MB */
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
    uint64_t framebuffer_addr;   /* 8 bytes per spec */
    uint32_t framebuffer_pitch;
    uint32_t framebuffer_width;
    uint32_t framebuffer_height;
    uint8_t  framebuffer_bpp;
    uint8_t  framebuffer_type;
} __attribute__((packed)) multiboot_info_t;

typedef struct {
    uint32_t mod_start;
    uint32_t mod_end;
    uint32_t cmdline;            /* module name when GRUB's second argument is used */
    uint32_t pad;
} __attribute__((packed)) multiboot_module_t;

/* One entry of the memory map, in the layout GRUB actually hands over:
 *
 *   size(4)  addr(8)  len(8)  type(4)      = 24 bytes
 *
 * Two things to know about it. The spec describes a 20 byte entry with a 32
 * bit length, which is not what arrives. And GRUB fills `size` in with 20
 * anyway, the size of that older shape, so walking the list by `size` lands in
 * the middle of the second entry. Use sizeof() as the stride and mmap_length
 * as the bound.
 */
typedef struct {
    uint32_t size;
    uint32_t addr_low;
    uint32_t addr_high;
    uint32_t len_low;
    uint32_t len_high;
    uint32_t type;
} __attribute__((packed)) multiboot_mmap_entry_t;

#endif