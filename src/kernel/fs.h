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
int  fs_file_count(void);
const fs_file_t* fs_get_file(int index);
const fs_file_t* fs_find(const char* name);

/* Finds a file anywhere on the disk by name alone, ignoring the folder it sits
 * in: fs_find_basename("prismtu.service") matches system/compiled/prismtu/
 * prismtu.service. The module list is flat, so this compares the last path
 * component of every name; a duplicate name in two folders resolves to whichever
 * was loaded first. */
const fs_file_t* fs_find_basename(const char* basename);

/* Byte count of the module behind a file handle. */
uint32_t fs_size(const fs_file_t* file);

#endif