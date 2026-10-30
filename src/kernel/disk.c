/* Cubic System Software - Disk and partition support */
/* ATA PIO. Enumerates the four possible ATA drives, reads each MBR and
 * exposes /dev/diskN and /dev/diskNsM with their sizes in bytes. */

#include "disk.h"
#include "console.h"
#include "io.h"

typedef struct {
    uint32_t start_lba;
    uint32_t sector_count;
    uint8_t  type;
    char     name[24];
} disk_partition_t;

typedef struct {
    int      present;
    uint32_t total_sectors;
    char     name[16];
    disk_partition_t parts[DISK_PART_MAX];
    int      part_count;
} disk_t;

static disk_t disks[DISK_MAX];
static int disk_total = 0;

static void delay400ns(uint16_t ctrl) {
    for (int i = 0; i < 4; i++)
        (void)inb(ctrl);
}

static int ata_identify(int channel, int drive, uint32_t* sectors) {
    uint16_t base = channel ? 0x170 : 0x1F0;
    uint16_t ctrl = channel ? 0x376 : 0x3F6;

    outb(base + 6, (uint8_t)(0xA0 | (drive << 4)));
    delay400ns(ctrl);

    outb(base + 2, 0);
    outb(base + 3, 0);
    outb(base + 4, 0);
    outb(base + 5, 0);
    outb(base + 7, 0xEC);          /* IDENTIFY */

    delay400ns(ctrl);

    uint8_t status = inb(base + 7);
    if (status == 0x00 || status == 0xFF)
        return 0;                  /* no drive there */

    int spin = 100000;
    while (spin-- > 0) {
        status = inb(base + 7);
        if (!(status & 0x80))
            break;
    }
    if (status & 0x01)
        return 0;                  /* error */

    spin = 100000;
    while (spin-- > 0) {
        status = inb(base + 7);
        if (status & 0x08)
            break;
        if (status & 0x01)
            return 0;
    }
    if (!(status & 0x08))
        return 0;

    uint16_t data[256];
    for (int i = 0; i < 256; i++)
        data[i] = inw(base);

    uint32_t lba28 = data[60] | ((uint32_t)data[61] << 16);

    uint64_t lba48 = (uint64_t)data[100] |
                      ((uint64_t)data[101] << 16) |
                      ((uint64_t)data[102] << 32) |
                      ((uint64_t)data[103] << 48);

    if (lba48 != 0 && lba48 < 0xFFFFFFFFu)
        *sectors = (uint32_t)lba48;
    else
        *sectors = lba28;

    if (*sectors == 0)
        return 0;

    return 1;
}

static int ata_read_sector(int channel, int drive, uint32_t lba, uint8_t* buffer) {
    uint16_t base = channel ? 0x170 : 0x1F0;
    uint16_t ctrl = channel ? 0x376 : 0x3F6;

    int spin = 100000;
    while (spin-- > 0) {
        if (!(inb(base + 7) & 0x80))
            break;
    }

    outb(base + 6, (uint8_t)(0xE0 | (drive << 4) | ((lba >> 24) & 0x0F)));
    delay400ns(ctrl);

    outb(base + 2, 1);                     /* sector count */
    outb(base + 3, (uint8_t)(lba & 0xFF));
    outb(base + 4, (uint8_t)((lba >> 8) & 0xFF));
    outb(base + 5, (uint8_t)((lba >> 16) & 0xFF));
    outb(base + 7, 0x20);                  /* READ SECTORS */

    delay400ns(ctrl);

    spin = 100000;
    while (spin-- > 0) {
        uint8_t s = inb(base + 7);
        if (s & 0x08)
            break;
        if (s & 0x01)
            return 0;
    }
    if (!(inb(base + 7) & 0x08))
        return 0;

    for (int i = 0; i < 256; i++) {
        uint16_t word = inw(base);
        buffer[i * 2] = (uint8_t)(word & 0xFF);
        buffer[i * 2 + 1] = (uint8_t)((word >> 8) & 0xFF);
    }

    return 1;
}


static int ata_write_sector(int channel, int drive, uint32_t lba, const uint8_t* buffer) {
    uint16_t base = channel ? 0x170 : 0x1F0;
    uint16_t ctrl = channel ? 0x376 : 0x3F6;

    int spin = 100000;
    while (spin-- > 0) {
        if (!(inb(base + 7) & 0x80))
            break;
    }

    outb(base + 6, (uint8_t)(0xE0 | (drive << 4) | ((lba >> 24) & 0x0F)));
    delay400ns(ctrl);

    outb(base + 2, 1);
    outb(base + 3, (uint8_t)(lba & 0xFF));
    outb(base + 4, (uint8_t)((lba >> 8) & 0xFF));
    outb(base + 5, (uint8_t)((lba >> 16) & 0xFF));
    outb(base + 7, 0x30);                  /* WRITE SECTORS */

    delay400ns(ctrl);

    spin = 100000;
    while (spin-- > 0) {
        uint8_t st = inb(base + 7);
        if (st & 0x08)
            break;
        if (st & 0x01)
            return 0;
    }
    if (!(inb(base + 7) & 0x08))
        return 0;

    for (int i = 0; i < 256; i++) {
        uint16_t word = (uint16_t)buffer[i * 2] |
                        ((uint16_t)buffer[i * 2 + 1] << 8);
        outw(base, word);
    }

    /* flush cache */
    outb(base + 7, 0xE7);
    spin = 100000;
    while (spin-- > 0) {
        if (!(inb(base + 7) & 0x80))
            break;
    }

    if (inb(base + 7) & 0x01)
        return 0;

    return 1;
}

static void make_name(char* out, int disk, int part) {
    /* /dev/diskN or /dev/diskNsM */
    char* p = out;
    const char* prefix = "/dev/disk";
    for (int i = 0; prefix[i]; i++)
        *p++ = prefix[i];

    /* disk number (only 0..9 here) */
    *p++ = (char)('0' + (disk % 10));

    if (part >= 0) {
        *p++ = 's';
        /* partition number 1..9 */
        *p++ = (char)('1' + (part % 9));
    }

    *p = '\0';
}

void disk_init(void) {
    for (int i = 0; i < DISK_MAX; i++) {
        disks[i].present = 0;
        disks[i].total_sectors = 0;
        disks[i].part_count = 0;
        disks[i].name[0] = '\0';
    }
    disk_total = 0;

    for (int channel = 0; channel < 2; channel++) {
        for (int drive = 0; drive < 2; drive++) {
            int index = channel * 2 + drive;
            if (index >= DISK_MAX)
                continue;

            uint32_t sectors = 0;
            if (!ata_identify(channel, drive, &sectors))
                continue;

            disks[index].present = 1;
            disks[index].total_sectors = sectors;
            make_name(disks[index].name, index, -1);

            /* Read MBR. */
            uint8_t mbr[512];
            if (!ata_read_sector(channel, drive, 0, mbr))
                continue;

            if (mbr[510] != 0x55 || mbr[511] != 0xAA)
                continue;

            int part_index = 0;
            for (int p = 0; p < 4; p++) {
                uint8_t* entry = &mbr[446 + p * 16];

                uint8_t type = entry[4];
                uint32_t start = entry[8] |
                                 ((uint32_t)entry[9] << 8) |
                                 ((uint32_t)entry[10] << 16) |
                                 ((uint32_t)entry[11] << 24);
                uint32_t count = entry[12] |
                                 ((uint32_t)entry[13] << 8) |
                                 ((uint32_t)entry[14] << 16) |
                                 ((uint32_t)entry[15] << 24);

                if (type == 0 || count == 0)
                    continue;

                if (part_index >= DISK_PART_MAX)
                    break;

                disks[index].parts[part_index].start_lba = start;
                disks[index].parts[part_index].sector_count = count;
                disks[index].parts[part_index].type = type;
                make_name(disks[index].parts[part_index].name, index, part_index);
                part_index++;
            }

            disks[index].part_count = part_index;
            disk_total++;
        }
    }
}

void disk_refresh(int disk_index) {
    if (disk_index < 0 || disk_index >= DISK_MAX)
        return;
    if (!disks[disk_index].present)
        return;

    /* Re-read MBR and re-parse. Keep total_sectors. */
    uint8_t mbr[512];
    int channel = disk_index / 2;
    int drive = disk_index % 2;

    if (!ata_read_sector(channel, drive, 0, mbr))
        return;

    if (mbr[510] != 0x55 || mbr[511] != 0xAA)
        return;

    disks[disk_index].part_count = 0;
    int part_index = 0;
    for (int p = 0; p < 4; p++) {
        uint8_t* entry = &mbr[446 + p * 16];

        uint8_t type = entry[4];
        uint32_t start = entry[8] |
                         ((uint32_t)entry[9] << 8) |
                         ((uint32_t)entry[10] << 16) |
                         ((uint32_t)entry[11] << 24);
        uint32_t count = entry[12] |
                         ((uint32_t)entry[13] << 8) |
                         ((uint32_t)entry[14] << 16) |
                         ((uint32_t)entry[15] << 24);

        if (type == 0 || count == 0)
            continue;

        if (part_index >= DISK_PART_MAX)
            break;

        disks[disk_index].parts[part_index].start_lba = start;
        disks[disk_index].parts[part_index].sector_count = count;
        disks[disk_index].parts[part_index].type = type;
        make_name(disks[disk_index].parts[part_index].name, disk_index, part_index);
        part_index++;
    }

    disks[disk_index].part_count = part_index;
}

int disk_create_partition(int disk_index, uint32_t size_sectors) {
    if (disk_index < 0 || disk_index >= DISK_MAX)
        return -1;
    if (!disks[disk_index].present)
        return -1;
    if (size_sectors == 0)
        return -1;

    int channel = disk_index / 2;
    int drive = disk_index % 2;

    uint8_t mbr[512];
    if (!ata_read_sector(channel, drive, 0, mbr))
        return -1;
    if (mbr[510] != 0x55 || mbr[511] != 0xAA)
        return -1;

    /* Find a free slot. */
    int slot = -1;
    for (int p = 0; p < 4; p++) {
        if (mbr[446 + p * 16 + 4] == 0) {
            slot = p;
            break;
        }
    }
    if (slot < 0)
        return -1;

    /* Compute start. */
    uint32_t start = 2048;
    for (int p = 0; p < 4; p++) {
        uint8_t type = mbr[446 + p * 16 + 4];
        if (type == 0)
            continue;
        uint32_t pstart = mbr[446 + p * 16 + 8] |
                          ((uint32_t)mbr[446 + p * 16 + 9] << 8) |
                          ((uint32_t)mbr[446 + p * 16 + 10] << 16) |
                          ((uint32_t)mbr[446 + p * 16 + 11] << 24);
        uint32_t pcount = mbr[446 + p * 16 + 12] |
                          ((uint32_t)mbr[446 + p * 16 + 13] << 8) |
                          ((uint32_t)mbr[446 + p * 16 + 14] << 16) |
                          ((uint32_t)mbr[446 + p * 16 + 15] << 24);
        uint32_t end = pstart + pcount;
        if (end > start)
            start = end;
    }

    /* Align to 2048. */
    if (start % 2048)
        start += 2048 - (start % 2048);

    if (start + size_sectors > disks[disk_index].total_sectors)
        return -1;

    /* Fill entry. */
    uint8_t* entry = &mbr[446 + slot * 16];
    for (int i = 0; i < 16; i++)
        entry[i] = 0;
    entry[4] = 0x0C;   /* FAT32 LBA */
    entry[8] = (uint8_t)(start & 0xFF);
    entry[9] = (uint8_t)((start >> 8) & 0xFF);
    entry[10] = (uint8_t)((start >> 16) & 0xFF);
    entry[11] = (uint8_t)((start >> 24) & 0xFF);
    entry[12] = (uint8_t)(size_sectors & 0xFF);
    entry[13] = (uint8_t)((size_sectors >> 8) & 0xFF);
    entry[14] = (uint8_t)((size_sectors >> 16) & 0xFF);
    entry[15] = (uint8_t)((size_sectors >> 24) & 0xFF);

    mbr[510] = 0x55;
    mbr[511] = 0xAA;

    if (!ata_write_sector(channel, drive, 0, mbr))
        return -1;

    disk_refresh(disk_index);
    return 0;
}

int disk_delete_partition(int disk_index, int partition_index) {
    if (disk_index < 0 || disk_index >= DISK_MAX)
        return -1;
    if (!disks[disk_index].present)
        return -1;
    if (partition_index < 0 || partition_index >= disks[disk_index].part_count)
        return -1;

    int channel = disk_index / 2;
    int drive = disk_index % 2;

    uint8_t mbr[512];
    if (!ata_read_sector(channel, drive, 0, mbr))
        return -1;
    if (mbr[510] != 0x55 || mbr[511] != 0xAA)
        return -1;

    /* Find the slot corresponding to partition_index (skip empty). */
    int slot = -1;
    int count = 0;
    for (int p = 0; p < 4; p++) {
        if (mbr[446 + p * 16 + 4] == 0)
            continue;
        if (count == partition_index) {
            slot = p;
            break;
        }
        count++;
    }

    if (slot < 0)
        return -1;

    for (int i = 0; i < 16; i++)
        mbr[446 + slot * 16 + i] = 0;

    mbr[510] = 0x55;
    mbr[511] = 0xAA;

    if (!ata_write_sector(channel, drive, 0, mbr))
        return -1;

    disk_refresh(disk_index);
    return 0;
}

int disk_count(void) {
    return disk_total;
}

int disk_partition_count(int disk_index) {
    if (disk_index < 0 || disk_index >= DISK_MAX)
        return 0;
    if (!disks[disk_index].present)
        return 0;
    return disks[disk_index].part_count;
}

const char* disk_device_name(int disk_index, int partition_index) {
    if (disk_index < 0 || disk_index >= DISK_MAX)
        return 0;
    if (!disks[disk_index].present)
        return 0;

    if (partition_index < 0)
        return disks[disk_index].name;

    if (partition_index >= disks[disk_index].part_count)
        return 0;

    return disks[disk_index].parts[partition_index].name;
}

uint64_t disk_device_size(const char* name) {
    if (!name)
        return 0;

    if (name[0] == '/' && name[1] == 'd' && name[2] == 'e' && name[3] == 'v' && name[4] == '/')
        name += 5;

    if (name[0] != 'd' || name[1] != 'i' || name[2] != 's' || name[3] != 'k')
        return 0;

    name += 4;

    if (*name < '0' || *name > '9')
        return 0;

    int disk = *name - '0';
    name++;

    if (disk < 0 || disk >= DISK_MAX || !disks[disk].present)
        return 0;

    if (*name == '\0')
        return (uint64_t)disks[disk].total_sectors * 512ull;

    if (*name != 's')
        return 0;

    name++;

    if (*name < '1' || *name > '9')
        return 0;

    int part = (*name - '1');
    name++;

    if (*name != '\0')
        return 0;

    if (part < 0 || part >= disks[disk].part_count)
        return 0;

    return (uint64_t)disks[disk].parts[part].sector_count * 512ull;
}

void disk_list(void) {
    int found = 0;

    for (int i = 0; i < DISK_MAX; i++) {
        if (!disks[i].present)
            continue;

        found = 1;

        console_printf("%-16s %12llu bytes  (%u sectors)\n",
                       disks[i].name,
                       (unsigned long long)disks[i].total_sectors * 512ull,
                       disks[i].total_sectors);

        for (int p = 0; p < disks[i].part_count; p++) {
            console_printf("  %-14s %12llu bytes  (%u sectors, type 0x%02x)\n",
                           disks[i].parts[p].name,
                           (unsigned long long)disks[i].parts[p].sector_count * 512ull,
                           disks[i].parts[p].sector_count,
                           disks[i].parts[p].type);
        }
    }

    if (!found)
        console_write("no ATA disks found\n");
}
