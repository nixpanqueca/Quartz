/* Cubic System Software - Text Console */
/* Plain 80x25 VGA text mode: 2000 characters, no pixels, no framebuffer. */

#ifndef CONSOLE_H
#define CONSOLE_H

#include <stdint.h>

#define CONSOLE_COLS 80
#define CONSOLE_ROWS 25

/* Standard VGA text attributes */
#define C_BLACK        0
#define C_BLUE         1
#define C_GREEN        2
#define C_CYAN         3
#define C_RED          4
#define C_MAGENTA      5
#define C_BROWN        6
#define C_LIGHTGRAY    7
#define C_DARKGRAY     8
#define C_LIGHTBLUE    9
#define C_LIGHTGREEN   10
#define C_LIGHTCYAN    11
#define C_LIGHTRED     12
#define C_LIGHTMAGENTA 13
#define C_YELLOW       14
#define C_WHITE        15

/* Which cell of each horizontal pair is lit. */
#define PATTERN_NONE   0
#define PATTERN_EVEN   1       /* columns 0, 2, 4, ... lit */
#define PATTERN_ODD    2       /* columns 1, 3, 5, ... lit */

void console_init(void);
void console_clear(void);
void console_clear_line(void);
void console_scroll(void);

/* Fills every cell with a one lit, one black pair, so at 80 columns the screen
 * reads as 40 vertical stripes. This is the text mode stand-in for setting
 * individual pixels: a character cell is the smallest thing the card will
 * light, so a cell is the pixel here, and "one pixel on, one pixel off" is a
 * pair of columns rather than a pair of characters.
 *
 * A lit cell is a space with a white background, which fills the cell edge to
 * edge whatever glyph the font uses for it. White is attribute 15 rather than 7
 * because 7 turns brown when blink is enabled, and the background is what
 * carries the pattern here, not the character.
 *
 * `pattern` is PATTERN_EVEN or PATTERN_ODD; passing the inverse of the current
 * pattern is what `dither invert` does. The cursor goes back to the top left so
 * printing still works over the fill. */
void console_fill_pattern(int pattern);

/* The same one lit / one black pattern, but over a rectangle and with an offset.
 *
 * This is the piece an animation needs. console_fill_pattern() always starts at
 * the top left and covers the whole screen, which is right for `dither on` and
 * useless for moving something around: it has no addressable cells and no
 * offset, so a shape cannot be placed or slid.
 *
 * (start_x, start_y) is the top left of the rectangle, width and height are its
 * size in cells. offset_x and offset_y shift the pattern without touching the
 * cursor, so a shape drawn with them can slide while the shell's own text stays
 * put. The pattern stays anchored to the screen rather than restarting inside the
 * rectangle, which is what makes a shape line up with the full screen fill it
 * sits on instead of showing stripes inside itself.
 *
 * Coordinates outside the screen are skipped rather than clipped, so a shape can
 * hang off any edge without writing outside the buffer or corrupting the cursor.
 * `pattern` is PATTERN_EVEN or PATTERN_ODD; anything else draws nothing. */
void console_put_cell_pattern(int start_x, int start_y, int width, int height,
                              int pattern, int offset_x, int offset_y);

/* Wipes the fill and parks the cursor at the top left. */
void console_pattern_off(void);

/* PATTERN_NONE, PATTERN_EVEN or PATTERN_ODD, so the shell can report and flip
 * it. Surviving a console_clear() is deliberate: clear wipes the screen, and a
 * fill that outlived it would be a lie. */
int  console_pattern(void);

void console_putc(char c);
void console_write(const char* text);
void console_write_n(const char* text, int length);
void console_printf(const char* fmt, ...) __attribute__((format(printf, 1, 2)));
void console_backspace(void);
void console_repeat(char c, int count);

void console_set_color(uint8_t foreground, uint8_t background);
void console_get_color(uint8_t* foreground, uint8_t* background);
void console_get_cursor(int* column, int* row);
void console_set_cursor(int column, int row);

/* Serial mirror: every character is also pushed out of COM1 so a broken screen
 * is still debuggable. On by default, `serial off` in the shell turns it off. */
void serial_init(void);
void serial_putc(char c);
void serial_write(const char* text);
void console_set_serial(int enabled);
int  console_get_serial(void);

#endif