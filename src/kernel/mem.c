/* Cubic System Software - Physical memory map */
/* The multiboot memory map GRUB hands over, kept in RAM so the shell can print
 * it. Before there was a framebuffer this information was thrown away. */

#include "mem.h"
#include "multiboot.h"

static multiboot_mmap_entry_t regions[MEM_MAX_REGIONS];
static int      region_count = 0;
static uint32_t total_kb = 0;
static uint32_t available_kb = 0;

/* The length field is 64 bits wide and nothing this kernel can address sits
 * above 4GB, so the low word is the answer and the high word only tells us
 * whether the value was truncated. */
static uint32_t entry_length(const multiboot_mmap_entry_t* entry) {
    return entry->len_low;
}

void mem_init(uint32_t mb_info_addr) {
    const multiboot_info_t* mb = (const multiboot_info_t*)(uintptr_t)mb_info_addr;

    region_count = 0;
    total_kb = 0;
    available_kb = 0;

    if (mb->flags & MB_MEMINFO)
        total_kb = mb->mem_lower + mb->mem_upper;

    if (!(mb->flags & MB_MEMINFO) || !(mb->flags & MB_MMAP))
        return;

    const uint8_t* base = (const uint8_t*)(uintptr_t)mb->mmap_addr;
    uint32_t offset = 0;

    /* The stride is sizeof() rather than entry.size on purpose: GRUB leaves
     * entry.size holding 20, the size of the 20 byte variant, while the entry
     * itself is 24 bytes wide. Walking by that field walks into the middle of
     * the next one. mmap_length is the only trustworthy bound. */
    while (offset + sizeof(multiboot_mmap_entry_t) <= mb->mmap_length &&
           region_count < MEM_MAX_REGIONS) {
        const multiboot_mmap_entry_t* entry =
            (const multiboot_mmap_entry_t*)(const void*)(base + offset);

        regions[region_count++] = *entry;

        if (entry->type == MEM_TYPE_AVAILABLE)
            available_kb += entry_length(entry) / 1024u;

        offset += (uint32_t)sizeof(multiboot_mmap_entry_t);
    }
}

uint32_t mem_total_kb(void) {
    return total_kb;
}

uint32_t mem_available_kb(void) {
    return available_kb;
}

uint32_t mem_available_mb(void) {
    return available_kb / 1024u;
}

int mem_region_count(void) {
    return region_count;
}

int mem_region(int index, uint32_t* base, uint32_t* length, uint32_t* type) {
    if (index < 0 || index >= region_count)
        return 0;

    if (base)   *base = regions[index].addr_low;
    if (length) *length = entry_length(&regions[index]);
    if (type)   *type = regions[index].type;

    return 1;
}

const char* mem_type_name(uint32_t type) {
    switch (type) {
        case MEM_TYPE_AVAILABLE:        return "available";
        case MEM_TYPE_RESERVED:         return "reserved";
        case MEM_TYPE_ACPI_RECLAIMABLE: return "ACPI reclaim";
        case MEM_TYPE_ACPI_NVS:         return "ACPI NVS";
        case MEM_TYPE_BADRAM:           return "bad RAM";
        default:                        return "unknown";
    }
}