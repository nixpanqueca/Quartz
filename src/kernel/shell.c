/* Cubic System Software - Quartz Shell */
/* A line editor and a small command table. This replaces Prism, which was
 * nothing but window rectangles and BMP blits. */

#include "shell.h"
#include "console.h"
#include "fs.h"
#include "io.h"
#include "keyboard.h"
#include "mem.h"
#include "openfirmware.h"
#include "prismtu.h"
#include "quartz.h"
#include "rtc.h"
#include "service.h"
#include "thread.h"
#include "timer.h"

#define LINE_MAX      256
#define HISTORY_MAX   16
#define MAX_ARGS      16

typedef struct {
    const char* name;
    const char* help;
    void (*run)(int argc, char** argv);
} shell_command_t;

static char line[LINE_MAX];
static int  line_length;
static int  cursor_offset;       /* where the caret sits inside line[0..length) */

static char history[HISTORY_MAX][LINE_MAX];
static int  history_count;
static int  history_cursor = -1;      /* -1 while editing a fresh line */
static char history_saved[LINE_MAX];

/* ---- String helpers (no libc in here) ---- */

static int str_length(const char* text) {
    int length = 0;

    while (text[length])
        length++;

    return length;
}

static void str_copy(char* destination, const char* source, int limit) {
    int i = 0;

    while (i < limit - 1 && source[i]) {
        destination[i] = source[i];
        i++;
    }

    destination[i] = '\0';
}

static int str_equal(const char* a, const char* b) {
    int i = 0;

    while (a[i] && b[i] && a[i] == b[i])
        i++;

    return a[i] == b[i];
}

static int char_equal(const char* text, int index, const char* other) {
    int i = 0;

    while (other[i]) {
        if (text[index + i] != other[i])
            return 0;
        i++;
    }

    return 1;
}

/* Substring search, so `ls prism` narrows things down without a full path. */
static int substring_match(const char* haystack, const char* needle) {
    if (needle[0] == '\0')
        return 1;

    for (int i = 0; haystack[i]; i++) {
        int j = 0;

        while (needle[j] && haystack[i + j] == needle[j])
            j++;

        if (needle[j] == '\0')
            return 1;
    }

    return 0;
}

static uint32_t parse_number(const char* text) {
    uint32_t value = 0;
    int base = 10;

    if (char_equal(text, 0, "0x") || char_equal(text, 0, "0X")) {
        base = 16;
        text += 2;
    } else if (text[0] == '0' && text[1] != '\0') {
        base = 8;
        text += 1;
    }

    for (int i = 0; text[i]; i++) {
        char c = text[i];
        int digit;

        if (c >= '0' && c <= '9')
            digit = c - '0';
        else if (c >= 'a' && c <= 'f')
            digit = c - 'a' + 10;
        else if (c >= 'A' && c <= 'F')
            digit = c - 'A' + 10;
        else
            break;

        if (digit >= base)
            break;

        value = value * (uint32_t)base + (uint32_t)digit;
    }

    return value;
}

/* ---- Prompt and line editor ---- */

static void prompt_draw(void) {
    uint8_t foreground = 0;
    uint8_t background = 0;

    console_get_color(&foreground, &background);

    console_set_color(C_YELLOW, background);
    console_write("Quartz");
    console_set_color(C_LIGHTGRAY, background);
    console_write("> ");

    console_set_color(foreground, background);
}

static void line_refresh(void) {
    console_clear_line();
    prompt_draw();
    console_write(line);

    /* Rewind to just after the prompt so the caret lands back where it was. */
    for (int i = line_length; i > cursor_offset; i--)
        console_backspace();
}

static void line_insert(char c) {
    if (line_length >= LINE_MAX - 1)
        return;

    for (int i = line_length; i > cursor_offset; i--)
        line[i] = line[i - 1];

    line[cursor_offset] = c;
    line_length++;
    line[line_length] = '\0';
    cursor_offset++;

    if (cursor_offset < line_length)
        line_refresh();           /* the tail moved, so redraw all of it */
    else
        console_putc(c);
}

static void line_delete_back(void) {
    if (cursor_offset == 0)
        return;

    for (int i = cursor_offset - 1; i < line_length; i++)
        line[i] = line[i + 1];

    line_length--;
    line[line_length] = '\0';
    cursor_offset--;

    line_refresh();
}

static void line_delete_forward(void) {
    if (cursor_offset >= line_length)
        return;

    for (int i = cursor_offset; i < line_length; i++)
        line[i] = line[i + 1];

    line_length--;
    line[line_length] = '\0';

    line_refresh();
}

static void history_push(const char* text) {
    if (text[0] == '\0')
        return;

    if (history_count > 0 && str_equal(history[history_count - 1], text))
        return;

    if (history_count < HISTORY_MAX) {
        str_copy(history[history_count], text, LINE_MAX);
        history_count++;
        return;
    }

    for (int i = 1; i < HISTORY_MAX; i++)
        str_copy(history[i - 1], history[i], LINE_MAX);

    str_copy(history[HISTORY_MAX - 1], text, LINE_MAX);
}

static void history_load(int index) {
    str_copy(line, history[index], LINE_MAX);
    line_length = str_length(line);
    cursor_offset = line_length;
    line_refresh();
}

static void history_previous(void) {
    if (history_count == 0)
        return;

    if (history_cursor < 0) {
        str_copy(history_saved, line, LINE_MAX);
        history_cursor = history_count - 1;
    } else if (history_cursor > 0) {
        history_cursor--;
    }

    history_load(history_cursor);
}

static void history_next(void) {
    if (history_cursor < 0)
        return;

    if (history_cursor < history_count - 1) {
        history_cursor++;
        history_load(history_cursor);
        return;
    }

    history_cursor = -1;
    str_copy(line, history_saved, LINE_MAX);
    line_length = str_length(line);
    cursor_offset = line_length;
    line_refresh();
}

/* ---- Commands ---- */

static void cmd_help(int argc, char** argv);
static void cmd_clear(int argc, char** argv);
static void cmd_echo(int argc, char** argv);
static void cmd_color(int argc, char** argv);
static void cmd_serial(int argc, char** argv);
static void cmd_version(int argc, char** argv);
static void cmd_uptime(int argc, char** argv);
static void cmd_date(int argc, char** argv);
static void cmd_mem(int argc, char** argv);
static void cmd_ls(int argc, char** argv);
static void cmd_cat(int argc, char** argv);
static void cmd_threads(int argc, char** argv);
static void cmd_services(int argc, char** argv);
static void cmd_start(int argc, char** argv);
static void cmd_run(int argc, char** argv);
static void cmd_stop(int argc, char** argv);
static void cmd_call(int argc, char** argv);
static void cmd_crash(int argc, char** argv);
static void cmd_dither(int argc, char** argv);
static void cmd_reboot(int argc, char** argv);

static const shell_command_t commands[] = {
    { "help",     "this list",                             cmd_help },
    { "clear",    "wipe the screen",                       cmd_clear },
    { "echo",     "echo <text...>",                        cmd_echo },
    { "color",    "color [foreground [background]]",       cmd_color },
    { "serial",   "serial [on|off], toggle the COM1 log",  cmd_serial },
    { "version",  "kernel version and build stamp",        cmd_version },
    { "uptime",   "ticks and wall time since boot",        cmd_uptime },
    { "date",     "date and time from the CMOS RTC",       cmd_date },
    { "mem",      "memory map handed over by GRUB",        cmd_mem },
    { "ls",       "ls [filter], list disk modules",        cmd_ls },
    { "cat",      "cat <file>, hex dump a module",         cmd_cat },
    { "threads",  "list scheduler threads",                cmd_threads },
    { "services", "list registered services",              cmd_services },
    { "start",    "start <name>, launch a .service",       cmd_start },
    { "run",      "run <path>, start a service",           cmd_run },
    { "stop",     "stop <path>, shut a service down",      cmd_stop },
    { "call",     "call <path> <func>, call one function", cmd_call },
    { "crash",    "crash [code], panic on purpose",        cmd_crash },
    { "dither",   "dither [on|off|invert], cell pattern",  cmd_dither },
    { "reboot",   "reset the machine",                     cmd_reboot },
    { 0, 0, 0 }
};

static const char* color_names[16] = {
    "black", "blue", "green", "cyan",
    "red", "magenta", "brown", "lightgray",
    "darkgray", "lightblue", "lightgreen", "lightcyan",
    "lightred", "lightmagenta", "yellow", "white"
};

static int color_lookup(const char* name) {
    for (int i = 0; i < 16; i++) {
        if (str_equal(name, color_names[i]))
            return i;
    }

    return -1;
}

static int command_lookup(const char* name) {
    for (int i = 0; commands[i].name; i++) {
        if (str_equal(commands[i].name, name))
            return i;
    }

    return -1;
}

static void command_execute(char* text) {
    char* argv[MAX_ARGS];
    int argc = 0;
    char* cursor = text;

    while (*cursor && argc < MAX_ARGS) {
        while (*cursor == ' ' || *cursor == '\t')
            *cursor++ = '\0';

        if (*cursor == '\0')
            break;

        argv[argc++] = cursor;

        while (*cursor && *cursor != ' ' && *cursor != '\t')
            cursor++;
    }

    if (argc == 0)
        return;

    /* Easter egg. Handled here rather than as an entry in commands[] on purpose:
     * cmd_help() walks that table, so a command living there would print itself
     * in the help listing. This way it is reachable but undiscoverable, which is
     * the point of it.
     *
     * Runs before command_lookup() because "911" is not a command name and would
     * otherwise be rejected as unknown.
     *
     * The match is on argc rather than on `text`: the loop above just wrote a
     * NUL over every space, so `text` now ends at the first argument. Comparing
     * the string alone would make "911 now" panic too, which is not what typing
     * exactly three digits should mean. */
    if (argc == 1 && str_equal(argv[0], "911")) {
        console_write("911\n");

        /* 0x911 is the code it dies with, so the panic screen identifies the
         * easter egg rather than looking like a real fault. */
        MacCrash("911", 0x911, 0);
    }

    int index = command_lookup(argv[0]);

    if (index < 0) {
        console_printf("%s: unknown command, try 'help'\n", argv[0]);
        return;
    }

    commands[index].run(argc, argv);
}

static void cmd_help(int argc, char** argv) {
    (void)argc;
    (void)argv;

    console_printf("\n%s %s commands:\n\n", QUARTZ_NAME, QUARTZ_VERSION);

    for (int i = 0; commands[i].name; i++) {
        console_printf("  %-9s %s\n", commands[i].name, commands[i].help);
    }

    console_printf("\n  type a command and press Enter. Arrow keys walk the\n"
                  "  history, Ctrl-C abandons the current line.\n\n");
}

static void cmd_clear(int argc, char** argv) {
    (void)argc;
    (void)argv;

    console_clear();
}

/* Fills every character cell as one lit, one black, and flips between the two
 * phases. A cell is the smallest thing the VGA will light, so the on/off pair is
 * a pair of columns: 80 columns reads as 40 stripes. */
static void cmd_dither(int argc, char** argv) {
    if (argc == 1) {
        int current = console_pattern();

        if (current == PATTERN_NONE)
            console_write("dither is off\n");
        else if (current == PATTERN_EVEN)
            console_write("dither is on, lit on the even columns\n");
        else
            console_write("dither is on, lit on the odd columns\n");

        return;
    }

    if (str_equal(argv[1], "on")) {
        console_fill_pattern(PATTERN_EVEN);
        console_write("dither on: even columns lit, 40 stripes\n");
        return;
    }

    if (str_equal(argv[1], "invert")) {
        int current = console_pattern();

        /* Flipping from off starts on, otherwise `invert` on a blank screen
         * would report success having changed nothing. */
        if (current == PATTERN_NONE)
            console_fill_pattern(PATTERN_EVEN);
        else if (current == PATTERN_EVEN)
            console_fill_pattern(PATTERN_ODD);
        else
            console_fill_pattern(PATTERN_EVEN);

        console_printf("dither inverted: lit on the %s columns\n",
                       console_pattern() == PATTERN_EVEN ? "even" : "odd");
        return;
    }

    if (str_equal(argv[1], "off")) {
        console_pattern_off();
        console_write("dither off\n");
        return;
    }

    console_write("usage: dither [on|off|invert]\n");
}

static void cmd_echo(int argc, char** argv) {
    for (int i = 1; i < argc; i++) {
        if (i > 1)
            console_putc(' ');
        console_write(argv[i]);
    }

    console_putc('\n');
}

static void cmd_color(int argc, char** argv) {
    if (argc == 1) {
        console_write("colours:");

        for (int i = 0; i < 16; i++)
            console_printf(" %d=%s", i, color_names[i]);

        console_putc('\n');
        return;
    }

    int foreground = color_lookup(argv[1]);
    uint8_t background = 0;

    console_get_color(0, &background);

    if (argc > 2) {
        int parsed = color_lookup(argv[2]);

        if (parsed < 0) {
            console_printf("color: no such background '%s'\n", argv[2]);
            return;
        }

        background = (uint8_t)parsed;
    }

    if (foreground < 0) {
        console_printf("color: no such colour '%s'\n", argv[1]);
        return;
    }

    console_set_color((uint8_t)foreground, background);
    console_printf("foreground is now %s\n", color_names[foreground]);
}

static void cmd_serial(int argc, char** argv) {
    if (argc == 1) {
        console_printf("serial mirror is %s\n",
                       console_get_serial() ? "on" : "off");
        return;
    }

    if (str_equal(argv[1], "on")) {
        console_set_serial(1);
        console_write("serial mirror on\n");
        return;
    }

    if (str_equal(argv[1], "off")) {
        console_set_serial(0);
        console_write("serial mirror off\n");
        return;
    }

    console_write("usage: serial [on|off]\n");
}

static void cmd_version(int argc, char** argv) {
    (void)argc;
    (void)argv;

    console_printf("%s %s\n", QUARTZ_NAME, QUARTZ_VERSION);
    console_printf("built %s %s\n", QUARTZ_BUILD_DATE, QUARTZ_BUILD_TIME);
    console_printf("text mode console, %ux%u, %u threads, %u services\n",
                   (uint32_t)CONSOLE_COLS, (uint32_t)CONSOLE_ROWS,
                   (uint32_t)thread_active_count(), service_count());
}

static void cmd_uptime(int argc, char** argv) {
    (void)argc;
    (void)argv;

    uint32_t seconds = timer_seconds();
    uint32_t ms = timer_ms();

    console_printf("up %u:%02u:%02u.%03u  (%u ticks at %u Hz)\n",
                   seconds / 3600u,
                   (seconds / 60u) % 60u,
                   seconds % 60u,
                   ms % 1000u,
                   timer_ticks(),
                   (uint32_t)TIMER_HZ);
}

static void cmd_date(int argc, char** argv) {
    (void)argc;
    (void)argv;

    static const char* weekdays[7] = {
        "Sunday", "Monday", "Tuesday", "Wednesday",
        "Thursday", "Friday", "Saturday"
    };

    uint8_t hour = 0, minute = 0, second = 0;
    uint8_t month = 0, day = 0, weekday = 0;
    uint16_t year = 0;

    rtc_get_time(&hour, &minute, &second);
    rtc_get_date(&year, &month, &day, &weekday);

    console_printf("%s %02u/%02u/%04u  %02u:%02u:%02u\n",
                   weekdays[weekday % 7], (uint32_t)day, (uint32_t)month,
                   (uint32_t)year, (uint32_t)hour, (uint32_t)minute,
                   (uint32_t)second);
}

static void cmd_mem(int argc, char** argv) {
    (void)argc;
    (void)argv;

    console_printf("legacy mem_lower+mem_upper : %u KB\n", mem_total_kb());
    console_printf("firmware usable total      : %u MB (%u KB)\n",
                   mem_available_mb(), mem_available_kb());
    console_printf("map entries                : %d\n\n", mem_region_count());

    console_write("  base        length       type\n");

    for (int i = 0; i < mem_region_count(); i++) {
        uint32_t base = 0, length = 0, type = 0;

        if (!mem_region(i, &base, &length, &type))
            continue;

        console_printf("  0x%08x  0x%08x  %s\n", base, length,
                       mem_type_name(type));
    }

    console_printf("\n  the kernel needs a page table before any of this above\n"
                   "  1MB is usable as ordinary memory.\n");
}

static void cmd_ls(int argc, char** argv) {
    const char* filter = (argc > 1) ? argv[1] : 0;
    int count = fs_file_count();

    if (count == 0) {
        console_write("no modules were handed over by GRUB\n");
        return;
    }

    console_printf("%-2s %-10s %s\n", "#", "bytes", "name");

    for (int i = 0; i < count; i++) {
        const fs_file_t* file = fs_get_file(i);

        if (!file)
            continue;

        if (filter && !substring_match(file->name, filter))
            continue;

        console_printf("%-2d %-10u %s\n", i, fs_size(file), file->name);
    }
}

static void cmd_cat(int argc, char** argv) {
    if (argc < 2) {
        console_write("usage: cat <file>\n");
        return;
    }

    const fs_file_t* file = fs_find(argv[1]);

    if (!file) {
        console_printf("cat: %s: no such module\n", argv[1]);
        return;
    }

    const uint8_t* data = (const uint8_t*)(uintptr_t)file->mod_start;
    uint32_t size = fs_size(file);

    console_printf("%s, %u bytes\n\n", file->name, size);

    for (uint32_t offset = 0; offset < size; offset += 16) {
        console_printf("%08x  ", offset);

        for (int i = 0; i < 16; i++) {
            if (offset + (uint32_t)i < size)
                console_printf("%02x ", data[offset + (uint32_t)i]);
            else
                console_write("   ");

            if (i == 7)
                console_putc(' ');
        }

        console_putc(' ');

        for (int i = 0; i < 16 && offset + (uint32_t)i < size; i++) {
            uint8_t c = data[offset + (uint32_t)i];

            console_putc((c >= 0x20 && c < 0x7F) ? (char)c : '.');
        }

        console_putc('\n');
    }
}

static void cmd_threads(int argc, char** argv) {
    (void)argc;
    (void)argv;

    console_printf("%-3s %-10s %-20s %s\n", "id", "state", "name", "esp");

    for (int i = 0; i < THREAD_MAX; i++) {
        const thread_t* thread = thread_get(i);

        if (!thread)
            continue;

        console_printf("%-3d %-10s %-20s 0x%08x\n", i,
                       thread_state_name(thread->state),
                       thread->name, thread->esp);
    }

    console_printf("\n%d active of %d slots\n", thread_active_count(), THREAD_MAX);
}

static void cmd_services(int argc, char** argv) {
    (void)argc;
    (void)argv;

    uint32_t count = service_count();

    if (count == 0) {
        console_write("no services registered\n");
        return;
    }

    console_printf("%-3s %-8s %-12s %s\n", "id", "type", "name", "path");

    for (uint32_t i = 0; i < count; i++) {
        const service_entry_t* service = service_get(i);

        if (!service)
            continue;

        console_printf("%-3u %-8s %-12s %s\n", i,
                       service_type_name(service->type),
                       service->name, service->path);
    }
}

/* Launches a service by name rather than by path.
 *
 * `start prismtu` looks for prismtu.service anywhere on the disk, in the root or
 * in any subfolder, resolves it to the path it actually has there, and then runs
 * the service registered under that path. That is what makes a service startable
 * by the name a user would type, the way a desktop launcher would.
 *
 * Note the split: the .service file on the disk is the manifest of record and
 * says where the service lives, while the code that actually runs is linked into
 * the kernel and registered under that same path. Finding the file but finding no
 * registration means the service was put on the disk without being built, which
 * is a different problem and is reported as such. */
static void cmd_start(int argc, char** argv) {
    if (argc < 2) {
        console_write("usage: start <name>\n");
        return;
    }

    /* The disk file is <name>.service. */
    char file[64];
    str_copy(file, argv[1], sizeof(file) - 9);
    str_copy(file + str_length(file), ".service", sizeof(file) - str_length(file));

    const fs_file_t* found = fs_find_basename(file);

    if (!found) {
        console_printf("start: no %s anywhere on the disk\n", file);
        return;
    }

    /* The service registry is keyed by the path with a leading slash, while the
     * module names GRUB hands over have none, so the slash goes on by hand:
     * there is no memmove here, or libc of any kind. */
    char path[128];

    path[0] = '/';
    str_copy(path + 1, found->name, sizeof(path) - 1);

    const service_entry_t* entry = service_find(path);

    if (!entry) {
        console_printf("start: %s is on the disk but no such service is "
                       "registered\n", file);
        console_write("  it was found at ");
        console_write(found->name);
        console_putc('\n');
        return;
    }

    console_printf("start: %s, at %s\n", entry->name, path);

    int result = service_run(path);

    if (result < 0)
        console_printf("start: %s has nothing to run\n", path);
}

static void cmd_run(int argc, char** argv) {
    if (argc < 2) {
        console_write("usage: run <path>\n");
        return;
    }

    int result = service_run(argv[1]);

    if (result < 0)
        console_printf("run: %s: no such service\n", argv[1]);
    else
        console_printf("run: %s: started\n", argv[1]);
}

static void cmd_stop(int argc, char** argv) {
    if (argc < 2) {
        console_write("usage: stop <path>\n");
        return;
    }

    int result = service_stop(argv[1]);

    if (result < 0)
        console_printf("stop: %s: could not shut it down\n", argv[1]);
    else
        console_printf("stop: %s: stopped\n", argv[1]);
}

static void cmd_call(int argc, char** argv) {
    if (argc < 3) {
        console_write("usage: call <path> <func>\n");
        return;
    }

    int result = service_call(argv[1], argv[2]);

    if (result < 0)
        console_printf("call: %s has no function '%s'\n", argv[1], argv[2]);
    else
        console_printf("call: %s.%s returned\n", argv[1], argv[2]);
}

static void cmd_crash(int argc, char** argv) {
    uint32_t code = 0;

    if (argc > 1)
        code = parse_number(argv[1]);

    console_printf("crash: about to panic with code 0x%08x\n", code);

    MacCrash("crash command from the shell", code, 0);
}

static void cmd_reboot(int argc, char** argv) {
    (void)argc;
    (void)argv;

    console_write("reboot: pulsing the 8042 reset line\n");

    for (volatile int i = 0; i < 1000000; i++)
        __asm__ __volatile__("nop");

    outb(0x64, 0xFE);            /* keyboard controller: pulse reset */

    for (;;)
        __asm__ __volatile__("hlt");
}

/* ---- Line editing ---- */

static void line_edit(void) {
    line_length = 0;
    line[0] = '\0';
    cursor_offset = 0;
    history_cursor = -1;

    for (;;) {
        keyboard_event_t event;

        if (!keyboard_wait_event(&event))
            continue;

        if (event.flags & KBD_FLAG_CTRL) {
            if (event.code == 'c' || event.code == 'd') {
                if (line_length == 0 && event.code == 'd') {
                    console_write("\nQuartz is not going anywhere yet.\n");
                    return;
                }

                line_length = 0;
                line[0] = '\0';
                cursor_offset = 0;
                history_cursor = -1;
                line_refresh();
            }

            continue;
        }

        switch (event.code) {
            case KEY_ENTER:
                console_putc('\n');
                line[line_length] = '\0';
                history_push(line);
                command_execute(line);
                line_length = 0;
                line[0] = '\0';
                cursor_offset = 0;
                history_cursor = -1;
                return;

            case KEY_BACKSPACE:
                line_delete_back();
                break;

            case KEY_DELETE:
                line_delete_forward();
                break;

            case KEY_ESCAPE:
                line_length = 0;
                line[0] = '\0';
                cursor_offset = 0;
                history_cursor = -1;
                line_refresh();
                break;

            case KEY_LEFT:
                if (cursor_offset > 0) {
                    cursor_offset--;
                    console_backspace();
                }
                break;

            case KEY_RIGHT:
                if (cursor_offset < line_length) {
                    console_putc(line[cursor_offset]);
                    cursor_offset++;
                }
                break;

            case KEY_HOME:
            case KEY_PAGEUP:
                while (cursor_offset > 0) {
                    console_backspace();
                    cursor_offset--;
                }
                break;

            case KEY_END:
            case KEY_PAGEDOWN:
                while (cursor_offset < line_length) {
                    console_putc(line[cursor_offset]);
                    cursor_offset++;
                }
                break;

            case KEY_UP:
                history_previous();
                break;

            case KEY_DOWN:
                history_next();
                break;

            default:
                if (event.code >= 0x20 && event.code < 0x7F)
                    line_insert((char)event.code);
                break;
        }
    }
}

void shell_init(void) {
    line_length = 0;
    line[0] = '\0';
    cursor_offset = 0;
    history_count = 0;
    history_cursor = -1;
    history_saved[0] = '\0';
}

void shell_run(void) {
    console_set_color(C_LIGHTGRAY, C_BLACK);
    console_printf("\n%s %s - text mode shell. Type 'help'.\n\n",
                   QUARTZ_NAME, QUARTZ_VERSION);

    for (;;) {
        prompt_draw();
        line_edit();
    }
}