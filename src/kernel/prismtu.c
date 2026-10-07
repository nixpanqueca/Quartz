/* Cubic System Software - PrismT, the text user interface */
/* The drawing primitives. Linked into the kernel so the shell, a command and the
 * PrismT service all render boxes the same way. See prismtu.h. */

// Code by NixPanqueca -w-

#include "prismtu.h"
#include "console.h"
#include "quartz.h"
#include "rtc.h"
#include "service.h"
#include "thread.h"
#include "timer.h"

/* ---- String helpers (no libc in here) ---- */

static int str_length(const char* text) {
    int length = 0;

    while (text[length])
        length++;

    return length;
}

/* ---- Boxes ---- */

void prismtu_box_rule(void) {
    console_putc('+');
    console_repeat('-', PRISMTU_BOX_WIDTH);
    console_putc('+');
    console_putc('\n');
}

void prismtu_box_open(void) {
    console_putc('|');
}

void prismtu_box_close(void) {
    int column = 0;
    int row = 0;

    console_get_cursor(&column, &row);

    while (column < PRISMTU_BOX_WIDTH) {
        console_putc(' ');
        column++;
    }

    console_putc('|');
    console_putc('\n');
}

void prismtu_box_line(const char* text) {
    prismtu_box_open();
    console_write(text);
    prismtu_box_close();
}

/* ---- Clock ---- */

void prismtu_clock_string(char* out) {
    uint8_t hour = 0;
    uint8_t minute = 0;
    uint8_t second = 0;

    rtc_get_time(&hour, &minute, &second);

    int pm = (hour >= 12);
    uint8_t twelve = (uint8_t)(hour % 12);

    if (twelve == 0)
        twelve = 12;

    out[0] = (char)('0' + twelve / 10);
    out[1] = (char)('0' + twelve % 10);
    out[2] = ':';
    out[3] = (char)('0' + minute / 10);
    out[4] = (char)('0' + minute % 10);
    out[5] = ' ';
    out[6] = pm ? 'P' : 'A';
    out[7] = pm ? 'M' : 'A';
    out[8] = '\0';
}

void prismtu_clock(void) {
    char clock[9];

    prismtu_clock_string(clock);

    console_printf("[prismtu] %s\n", clock);
}

/* ---- Menu bar ---- */

void prismtu_menubar(void) {
    char clock[9];
    const char* menus = "  File  Edit  View  Special";
    int gap = CONSOLE_COLS - str_length(menus) - str_length(PRISMTU_TITLE) - 12;

    if (gap < 1)
        gap = 1;

    prismtu_clock_string(clock);

    console_set_color(C_BLACK, C_LIGHTGRAY);
    console_printf("%s", menus);
    console_repeat(' ', gap);
    console_printf("%s | %s", PRISMTU_TITLE, clock);
    console_putc('\n');
    console_set_color(C_LIGHTGRAY, C_BLACK);
}

/* ---- Splash and about ---- */

void prismtu_splash(void) {
    console_set_color(C_LIGHTGRAY, C_BLACK);
    prismtu_box_rule();

    console_set_color(C_WHITE, C_BLACK);
    prismtu_box_line("");
    prismtu_box_open();
    console_printf("  %s %s", QUARTZ_NAME, QUARTZ_VERSION);
    prismtu_box_close();

    console_set_color(C_LIGHTGRAY, C_BLACK);
    prismtu_box_line("");
    prismtu_box_line("  PrismT, the text mode desktop");
    prismtu_box_line("");

    prismtu_box_open();
    console_printf("  uptime   %u s", timer_seconds());
    prismtu_box_close();

    prismtu_box_open();
    console_printf("  threads  %d of %d", thread_active_count(), THREAD_MAX);
    prismtu_box_close();

    prismtu_box_open();
    console_printf("  services %u", service_count());
    prismtu_box_close();

    prismtu_box_rule();
    console_putc('\n');
}

void prismtu_about(void) {
    console_set_color(C_LIGHTGRAY, C_BLACK);
    prismtu_box_rule();

    console_set_color(C_WHITE, C_BLACK);
    prismtu_box_line("  About PrismT");
    prismtu_box_line("");

    console_set_color(C_LIGHTGRAY, C_BLACK);
    prismtu_box_open();
    console_printf("  title    %s", PRISMTU_TITLE);
    prismtu_box_close();

    prismtu_box_open();
    console_printf("  version  %s", QUARTZ_VERSION);
    prismtu_box_close();

    prismtu_box_open();
    console_printf("  console  %ux%u text", (uint32_t)CONSOLE_COLS,
                   (uint32_t)CONSOLE_ROWS);
    prismtu_box_close();

    prismtu_box_rule();
    console_putc('\n');
}