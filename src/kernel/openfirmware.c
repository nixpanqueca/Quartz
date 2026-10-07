/* Micro OpenFirmware Recreation */

// Code by NixPanqueca -w-

#include "openfirmware.h"
#include "console.h"
#include "fs.h"
#include "interrupt.h"
#include "keyboard.h"
#include "timer.h"

/* Characters between the vertical bars */
#define OF_BOX_WIDTH 60

/* The code the framebuffer build passed when a disk file was missing. */
#define OF_CODE_MISSING_FILE 0x00194u

/* How long the o+f chord stays live after the banner, in ticks. */
#define OF_CHORD_TICKS 300

static void box_rule(void) {
    console_putc('+');
    console_repeat('-', OF_BOX_WIDTH);
    console_putc('+');
    console_putc('\n');
}

static void box_open(void) {
    console_putc('|');
}

/* Closes the row the cursor is sitting on. Every row goes through this, so a row
 * built with console_printf still lines up with the rule above it. */
static void box_close(void) {
    int column = 0;
    int row = 0;

    console_get_cursor(&column, &row);

    while (column < OF_BOX_WIDTH) {
        console_putc(' ');
        column++;
    }

    console_putc('|');
    console_putc('\n');
}

static void box_line(const char* text) {
    box_open();
    console_write(text);
    box_close();
}

__attribute__((noreturn))
static void halt_forever(void) {
    __asm__ __volatile__("cli");

    for (;;)
        __asm__ __volatile__("hlt");
}

/* The crash screen. Used to be two things: a MacCrash() that drew a box and
 * halted, and a separate panic() / panic_registers() pair in panic.c that drew a
 * richer version of the same box. One screen, one entry point.
 *
 * `frame` is the register state the exception stubs in isr.asm build, and is what
 * makes a real fault readable: without it the screen can only report that
 * something asked to stop. Pass 0 when there is nothing to show, which is every
 * deliberate panic. */
__attribute__((noreturn))
void MacCrash(const char* reason, uint32_t code, const uint32_t* frame) {
    /* Whatever broke, the screen is the first thing to doubt: send everything
     * down the serial line before drawing a single character. */
    console_set_serial(1);
    console_clear();

    console_set_color(C_LIGHTRED, C_BLACK);
    box_rule();

    console_set_color(C_WHITE, C_BLACK);
    box_line("  System crashed");
    box_line("");

    console_set_color(C_WHITE, C_BLACK);
    box_open();
    console_write("  reason : ");
    console_write(reason ? reason : "unknown failure");
    box_close();

    box_open();
    console_printf("  code   : 0x%08x", code);
    box_close();

    if (code == OF_CODE_MISSING_FILE) {
        console_set_color(C_YELLOW, C_BLACK);
        box_open();
        console_write("  a system file was missing from the boot disk");
        box_close();
    }

    if (frame) {
        console_set_color(C_WHITE, C_BLACK);

        box_open();
        console_printf("  eip    : 0x%08x   cs 0x%04x   error 0x%04x",
                       frame[REG_EIP], (uint32_t)frame[REG_CS],
                       frame[REG_ERROR]);
        box_close();

        box_open();
        console_printf("  eax %08x  ebx %08x  ecx %08x",
                       frame[REG_EAX], frame[REG_EBX], frame[REG_ECX]);
        box_close();

        box_open();
        console_printf("  edx %08x  esi %08x  edi %08x",
                       frame[REG_EDX], frame[REG_ESI], frame[REG_EDI]);
        box_close();
    } else {
        console_set_color(C_WHITE, C_BLACK);
        box_open();
        console_write("  eip    : unavailable");
        box_close();
    }

    console_set_color(C_LIGHTGRAY, C_BLACK);
    box_rule();
    box_line("  The kernel stopped. Reset the machine to continue.");
    box_rule();

    halt_forever();
}

void OpenFirmware(void) {
    console_set_color(C_LIGHTGRAY, C_BLACK);
    box_rule();

    console_set_color(C_WHITE, C_BLACK);
    box_line("  Open Firmware");
    box_line("");

    console_set_color(C_LIGHTGRAY, C_BLACK);
    box_open();
    console_write("  boot entries");
    box_close();

    /* The modules GRUB loaded are the closest thing this kernel has to a disk
     * catalog, so they are what the firmware screen offers to boot. */
    int count = fs_file_count();

    if (count == 0) {
        console_set_color(C_LIGHTRED, C_BLACK);
        box_open();
        console_write("  (none: GRUB handed over no modules)");
        box_close();
    } else {
        for (int i = 0; i < count; i++) {
            const fs_file_t* file = fs_get_file(i);

            if (!file)
                continue;

            box_open();
            console_printf("  %-2d %s", i, file->name);
            box_close();
        }
    }

    console_set_color(C_LIGHTGRAY, C_BLACK);
    box_rule();

    console_set_color(C_LIGHTGRAY, C_BLACK);
    console_write("  press any key to continue\n");
    console_putc('\n');

    keyboard_event_t event;

    keyboard_wait_event(&event);
}

void OFinit(void) {
    console_set_color(C_WHITE, C_BLACK);
    console_write("\n  uOFW ver. 0.1\n");

    /* The bitmap the framebuffer build showed here is gone, but a disk that
     * is missing its system files is still worth complaining about. */
    if (!fs_find("/system/compiled/bitmap/face@2x.bmp")) {
        console_set_color(C_YELLOW, C_BLACK);
        console_write("  warning: no system bitmaps on this disk (harmless in text mode)\n");
    }

    console_set_color(C_LIGHTGRAY, C_BLACK);

    int saw_o = 0;
    int saw_f = 0;
    int32_t deadline = (int32_t)(timer_ticks() + OF_CHORD_TICKS);

    while ((int32_t)(timer_ticks() - deadline) < 0) {
        keyboard_event_t event;

        while (keyboard_get_event(&event)) {
            if (event.flags & KBD_FLAG_CTRL)
                continue;

            if (event.code == 'o') saw_o = 1;
            if (event.code == 'f') saw_f = 1;
        }

        if (saw_o && saw_f)
            break;

        timer_sleep(10);
    }

    if (saw_o && saw_f)
        OpenFirmware();
}