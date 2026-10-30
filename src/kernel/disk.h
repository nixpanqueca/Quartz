/* Cubic System Software - Disk and partition support */
/* ATA PIO disks, enumerated at boot. Devices are named /dev/diskNsM,
 * where N is the disk index and M is the partition index (1 based). A
 * whole disk is /dev/diskN. */

#ifndef DISK_H
#define DISK_H

#include <stdint.h>

#define DISK_MAX        4
#define DISK_PART_MAX   8

void disk_init(void);

int disk_count(void);
int disk_partition_count(int disk_index);

/* Whole disk when partition_index < 0. Returns a pointer to a static buffer. */
const char* disk_device_name(int disk_index, int partition_index);

/* Size in bytes. 0 means "not found". */
uint64_t disk_device_size(const char* name);

/* Create a primary partition of the given size in sectors. 0 on success. */
int disk_create_partition(int disk_index, uint32_t size_sectors);

/* Delete a primary partition by index. 0 on success. */
int disk_delete_partition(int disk_index, int partition_index);

/* Re-read the MBR of one disk. */
void disk_refresh(int disk_index);

/* Pretty printer for the shell. */
void disk_list(void);

#endif
