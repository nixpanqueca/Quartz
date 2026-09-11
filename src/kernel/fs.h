/* Cubic System Software - Filesystem (multiboot modules) */

#ifndef FS_H
#define FS_H

#include <stdint.h>

typedef struct {
    uint32_t mod_start;
    uint32_t mod_end;
    const char* name;
} fs_file_t;

void fs_init(uint32_t mb_info_addr);
int fs_file_count(void);
const fs_file_t* fs_get_file(int index);
const fs_file_t* fs_find(const char* name);

void FB_drawbmp(uint32_t x, uint32_t y, const void* bmp_data);

#endif
