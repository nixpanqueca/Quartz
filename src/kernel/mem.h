/* Cubic System Software - Physical memory map */
/* The multiboot memory map GRUB hands over, kept in RAM so the shell can print
 * it. Before there was a framebuffer this information was thrown away. */

#ifndef MEM_H
#define MEM_H

#include <stdint.h>

#define MEM_TYPE_AVAILABLE           1
#define MEM_TYPE_RESERVED            2
#define MEM_TYPE_ACPI_RECLAIMABLE    3
#define MEM_TYPE_ACPI_NVS            4
#define MEM_TYPE_BADRAM              5

#define MEM_MAX_REGIONS 128

void mem_init(uint32_t mb_info_addr);

/* Legacy mem_lower + mem_upper. Zero when the loader did not report it. */
uint32_t mem_total_kb(void);

/* Sum of every region the firmware called usable. Wraps past 4TB, which is a
 * problem for a 32-bit kernel far in the future. */
uint32_t mem_available_kb(void);
uint32_t mem_available_mb(void);

int mem_region_count(void);

/* Returns 0 when index is out of range. length is in bytes. */
int mem_region(int index, uint32_t* base, uint32_t* length, uint32_t* type);

const char* mem_type_name(uint32_t type);

#endif