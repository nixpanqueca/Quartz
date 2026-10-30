/* Cubic System Software - Disk Manager */
/* A diskpart-like interactive CLI for ATA disks and MBR partitions. */

// Code by NixPanqueca -w-

#include "quartz.h"
#include "console.h"
#include "disk.h"
#include "keyboard.h"
#include "service.h"

static int running = 0;
static int selected_disk = -1;
static int selected_part = -1;

/* ---- string helpers (no libc) ---- */

static int str_equal(const char* a, const char* b) {
    int i = 0;
    while (a[i] && b[i] && a[i] == b[i])
        i++;
    return a[i] == b[i];
}

static int starts_with(const char* text, const char* prefix) {
    int i = 0;
    while (prefix[i]) {
        if (text[i] != prefix[i])
            return 0;
        i++;
    }
    return 1;
}

static int parse_uint(const char* text) {
    int value = 0;
    int i = 0;

    while (text[i] == ' ' || text[i] == '\t')
        i++;

    if (text[i] < '0' || text[i] > '9')
        return -1;

    while (text[i] >= '0' && text[i] <= '9') {
        value = value * 10 + (text[i] - '0');
        i++;
    }

    return value;
}

/* ---- line input ---- */

static void read_line(char* buffer, int limit) {
    int length = 0;
    buffer[0] = '\0';

    for (;;) {
        keyboard_event_t event;

        if (!keyboard_wait_event(&event))
            continue;

        if (event.flags & KBD_FLAG_CTRL) {
            if (event.code == 'c') {
                length = 0;
                buffer[0] = '\0';
                console_putc('\n');
                return;
            }
            continue;
        }

        switch (event.code) {
            case KEY_ENTER:
                console_putc('\n');
                buffer[length] = '\0';
                return;

            case KEY_BACKSPACE:
                if (length > 0) {
                    length--;
                    buffer[length] = '\0';
                    console_backspace();
                }
                break;

            default:
                if (event.code >= 0x20 && event.code < 0x7F &&
                    length < limit - 1) {
                    buffer[length] = event.code;
                    length++;
                    buffer[length] = '\0';
                    console_putc((char)event.code);
                }
                break;
        }
    }
}

/* ---- command handlers ---- */

static void cmd_help(void) {
    console_write("Commands:\n");
    console_write("  help                      this list\n");
    console_write("  list disk                 list disks\n");
    console_write("  list partition            list partitions of selected disk\n");
    console_write("  select disk N             select disk N\n");
    console_write("  select partition N        select partition N\n");
    console_write("  detail disk               show selected disk\n");
    console_write("  detail partition          show selected partition\n");
    console_write("  create partition primary [size=N]   N in MB\n");
    console_write("  delete partition          delete selected partition\n");
    console_write("  exit                      leave DiskPart\n");
}

static void cmd_list_disk(void) {
    int found = 0;

    for (int i = 0; i < 4; i++) {
        const char* name = disk_device_name(i, -1);
        if (!name)
            continue;

        found = 1;
        uint64_t size = disk_device_size(name);

        console_printf("  Disk %d    %llu MB%s\n", i,
                       (unsigned long long)(size / (1024ull * 1024ull)),
                       (i == selected_disk) ? "   *" : "");
    }

    if (!found)
        console_write("  no disks found\n");
}

static void cmd_list_partition(void) {
    if (selected_disk < 0) {
        console_write("No disk selected. Use 'select disk N'.\n");
        return;
    }

    int count = disk_partition_count(selected_disk);
    if (count == 0) {
        console_write("  no partitions\n");
        return;
    }

    for (int i = 0; i < count; i++) {
        const char* name = disk_device_name(selected_disk, i);
        uint64_t size = disk_device_size(name);

        console_printf("  Partition %d    %llu MB%s\n", i + 1,
                       (unsigned long long)(size / (1024ull * 1024ull)),
                       (i == selected_part) ? "   *" : "");
    }
}

static void cmd_select_disk(const char* arg) {
    int n = parse_uint(arg);
    if (n < 0 || !disk_device_name(n, -1)) {
        console_write("invalid disk\n");
        return;
    }
    selected_disk = n;
    selected_part = -1;
    console_printf("Disk %d is now the selected disk.\n", n);
}

static void cmd_select_partition(const char* arg) {
    if (selected_disk < 0) {
        console_write("No disk selected.\n");
        return;
    }
    int n = parse_uint(arg);
    if (n < 1 || n > disk_partition_count(selected_disk)) {
        console_write("invalid partition\n");
        return;
    }
    selected_part = n - 1;
    console_printf("Partition %d is now the selected partition.\n", n);
}

static void cmd_detail_disk(void) {
    if (selected_disk < 0) {
        console_write("No disk selected.\n");
        return;
    }
    const char* name = disk_device_name(selected_disk, -1);
    uint64_t size = disk_device_size(name);

    console_printf("Disk %d\n", selected_disk);
    console_printf("  size: %llu bytes (%llu MB)\n",
                   (unsigned long long)size,
                   (unsigned long long)(size / (1024ull * 1024ull)));
    console_printf("  partitions: %d\n", disk_partition_count(selected_disk));
}

static void cmd_detail_partition(void) {
    if (selected_disk < 0 || selected_part < 0) {
        console_write("No partition selected.\n");
        return;
    }
    const char* name = disk_device_name(selected_disk, selected_part);
    uint64_t size = disk_device_size(name);

    console_printf("Partition %d on Disk %d\n", selected_part + 1, selected_disk);
    console_printf("  device: %s\n", name);
    console_printf("  size: %llu bytes (%llu MB)\n",
                   (unsigned long long)size,
                   (unsigned long long)(size / (1024ull * 1024ull)));
}

static void cmd_create(const char* line) {
    if (selected_disk < 0) {
        console_write("No disk selected.\n");
        return;
    }

    /* parse size= in MB; default 64 MB */
    uint32_t size_mb = 64;
    const char* p = line;
    while (*p) {
        if (starts_with(p, "size=")) {
            int v = parse_uint(p + 5);
            if (v > 0)
                size_mb = (uint32_t)v;
            break;
        }
        p++;
    }

    uint32_t size_sectors = size_mb * 2048u;

    if (disk_create_partition(selected_disk, size_sectors) == 0) {
        console_write("Partition created.\n");
        int c = disk_partition_count(selected_disk);
        if (c > 0)
            selected_part = c - 1;
    } else {
        console_write("Failed to create partition.\n");
    }
}

static void cmd_delete(void) {
    if (selected_disk < 0 || selected_part < 0) {
        console_write("No partition selected.\n");
        return;
    }

    if (disk_delete_partition(selected_disk, selected_part) == 0) {
        console_write("Partition deleted.\n");
        selected_part = -1;
    } else {
        console_write("Failed to delete partition.\n");
    }
}

static void run_cli(void) {
    char line[128];

    console_write("DiskPart clone. Type 'help'.\n");

    for (;;) {
        console_write("DISKPART> ");
        read_line(line, sizeof(line));

        if (str_equal(line, "exit") || str_equal(line, "quit"))
            break;
        else if (str_equal(line, "help") || str_equal(line, "?"))
            cmd_help();
        else if (str_equal(line, "list disk"))
            cmd_list_disk();
        else if (str_equal(line, "list partition"))
            cmd_list_partition();
        else if (starts_with(line, "select disk"))
            cmd_select_disk(line + 11);
        else if (starts_with(line, "select partition"))
            cmd_select_partition(line + 16);
        else if (str_equal(line, "detail disk"))
            cmd_detail_disk();
        else if (str_equal(line, "detail partition"))
            cmd_detail_partition();
        else if (starts_with(line, "create partition primary"))
            cmd_create(line);
        else if (str_equal(line, "delete partition"))
            cmd_delete();
        else if (line[0] == '\0')
            continue;
        else
            console_write("Unknown command. Type 'help'.\n");
    }
}

/* ---- service boilerplate ---- */

static int running_flag = 0;

static service_func_t diskmgr_funcs[] = {
    { "cli", run_cli },
    { 0, 0 }
};

void Init(void) {
    running = 1;
    running_flag = 1;
    console_write("[diskmgr] Init\n");
    run_cli();
}

void Shutdown(void) {
    running = 0;
    running_flag = 0;
    console_write("[diskmgr] Shutdown\n");
}

SERVICE_REGISTER("/system/compiled/utils/diskmgr.app", "DiskMgr", SERVICE_TYPE_APP, diskmgr_funcs)
