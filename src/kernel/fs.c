/* Cubic System Software - Filesystem (multiboot modules) */
/* GRUB loads files as modules before handing over; this indexes them so the
 * shell can list and dump them. */

#include "fs.h"
#include "console.h"
#include "multiboot.h"

#define MAX_MODULES 32

static fs_file_t files[MAX_MODULES];
static int file_count = 0;

void fs_init(uint32_t mb_info_addr) {
    const multiboot_info_t* mb = (const multiboot_info_t*)(uintptr_t)mb_info_addr;

    file_count = 0;

    if (!(mb->flags & MB_MODS) || mb->mods_count == 0) {
        console_write("[boot] GRUB passed over no modules\n");
        return;
    }

    uint32_t count = mb->mods_count;
    const multiboot_module_t* modules =
        (const multiboot_module_t*)(uintptr_t)mb->mods_addr;

    if (count > MAX_MODULES) {
        console_printf("[boot] only tracking the first %d of %u modules\n",
                       MAX_MODULES, count);
        count = MAX_MODULES;
    }

    for (uint32_t i = 0; i < count; i++) {
        if (modules[i].mod_end <= modules[i].mod_start)
            continue;

        files[file_count].mod_start = modules[i].mod_start;
        files[file_count].mod_end = modules[i].mod_end;
        files[file_count].name =
            (const char*)(uintptr_t)modules[i].cmdline;

        /* GRUB leaves cmdline empty if the module was declared without a
         * destination name, and every caller here assumes a valid string. */
        if (!files[file_count].name)
            files[file_count].name = "unnamed";

        file_count++;
    }

    console_printf("[boot] %d module(s) on disk\n", file_count);
}

int fs_file_count(void) {
    return file_count;
}

const fs_file_t* fs_get_file(int index) {
    if (index < 0 || index >= file_count) return 0;
    return &files[index];
}

const fs_file_t* fs_find(const char* name) {
    if (!name)
        return 0;

    if (*name == '/')
        name++;                       /* tolerate both /system/x and system/x */

    for (int i = 0; i < file_count; i++) {
        const char* a = files[i].name;
        const char* b = name;

        while (*a && *b && *a == *b) { a++; b++; }
        if (*a == *b) return &files[i];
    }

    return 0;
}

uint32_t fs_size(const fs_file_t* file) {
    if (!file || file->mod_end <= file->mod_start)
        return 0;

    return file->mod_end - file->mod_start;
}

/* Compares the last path component of a module name against a bare file name. */
static int tail_is(const char* path, const char* basename) {
    const char* tail = path;

    for (const char* p = path; *p; p++) {
        if (*p == '/')
            tail = p + 1;
    }

    const char* a = tail;
    const char* b = basename;

    while (*a && *b && *a == *b) { a++; b++; }

    return *a == *b;
}

/* Finds a file anywhere on the disk by its name alone, ignoring where it sits.
 *
 * The modules are a flat list with no directory tree behind them, so "search
 * every subfolder" means comparing the last path component of each name
 * rather than walking a hierarchy. Two files with the same name in different
 * folders both match and the first one loaded wins. */
const fs_file_t* fs_find_basename(const char* basename) {
    if (!basename || !*basename)
        return 0;

    /* Skip a leading slash so both prismtu.service and /prismtu.service work. */
    if (*basename == '/')
        basename++;

    for (int i = 0; i < file_count; i++) {
        if (tail_is(files[i].name, basename))
            return &files[i];
    }

    return 0;
}