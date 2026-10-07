/* Cubic System Software - PrismT, the text user interface */
/* TU = Text-UI: the Windows 1.0 idea, a small windowed interface over a text
 * console, with no framebuffer anywhere.
 *
 * This is the drawing toolbox, linked into the kernel rather than into the
 * service, so the shell, a command and the PrismT service all draw the same
 * boxes through the same code. The service is left with nothing but the service
 * boilerplate, and the UI can grow here without it having to be reimplemented per
 * caller.
 *
 * Everything here writes characters. There is no pixel anywhere: a box edge is a
 * character, and the "interior" is whatever the console already had.
 */

#ifndef PRISMTU_H
#define PRISMTU_H

#include <stdint.h>

/* Characters between the vertical bars of a box. */
#define PRISMTU_BOX_WIDTH 62

/* The application title PrismT shows in its menu bar. */
#define PRISMTU_TITLE "PrismT"

/* Box drawing. These write at the cursor and advance it, exactly like
 * console_putc does.
 *
 * prismtu_box_close() pads with spaces to the box width and ends the line, so a
 * row built with console_printf in between the open and the close still lines up
 * with the rule above it. prismtu_box_line() is the common case: a whole row from
 * one string. */
void prismtu_box_rule(void);
void prismtu_box_open(void);
void prismtu_box_close(void);
void prismtu_box_line(const char* text);

/* The menu bar: application menus on the left, the title and the CMOS clock on
 * the right, on one highlighted row, the way Prism used to draw it. */
void prismtu_menubar(void);

/* The clock on its own, "HH:MM XM", the format the menubar used. Writes into
 * `out`, which needs room for 9 bytes including the terminator. */
void prismtu_clock_string(char* out);
void prismtu_clock(void);

/* The startup splash: name, version, uptime, thread and service counts, framed. */
void prismtu_splash(void);

/* The about box: title, version and console geometry, framed. */
void prismtu_about(void);

#endif