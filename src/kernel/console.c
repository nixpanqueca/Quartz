/* Cubic System Software - Text Console */
/* Plain 80x25 VGA text mode: 2000 characters, no pixels, no framebuffer. */

#include "console.h"
#include "io.h"

#define VGA_BUFFER ((volatile uint16_t*)(uintptr_t)0xB8000u)

#define VGA_CURSOR_INDEX   0x3D4
#define VGA_CURSOR_DATA    0x3D5

#define SERIAL_PORT        0x3F8
#define SERIAL_DATA_READY  0x20    /* bit 5 of the line status register */

/* The UART can be absent on bare metal, so every wait is bounded instead of
 * spinning forever and hanging the kernel. */
#define SERIAL_SPIN_LIMIT  100000

static int      cursor_column = 0;
static int      cursor_row = 0;
static uint8_t  foreground = C_LIGHTGRAY;
static uint8_t  background = C_BLACK;
static int      mirror_serial = 1;

/* Which cell of each pair the full screen fill lights: PATTERN_NONE, PATTERN_EVEN
 * or PATTERN_ODD. Declared up here because console_clear() has to reset it and
 * console_fill_pattern() has to set it. */
static int      pattern = PATTERN_NONE;

/* The two cells the fill is made of, precomputed.
 *
 * A cell is the character in the low byte and the attribute in the high byte.
 * Inside the attribute byte the background is the high nibble and the foreground
 * the low one, so a white cell is 0xF0: white shifted into the background nibble,
 * then the whole attribute shifted into the high byte.
 *
 * Two ways to get this wrong, both of which read back as a plausible histogram
 * while drawing nothing: leaving the attribute in the low byte, so the colour
 * becomes part of the character, and using the foreground nibble, which for a
 * space is the colour of nothing.
 *
 * White is attribute 15 rather than 7 on purpose: attribute 7 renders as brown
 * whenever blink is enabled, and here the background carries the pattern, so it
 * has to be a colour that cannot change meaning.
 *
 * A space with a lit background rather than a glyph: the background paints the
 * whole cell whatever the font does with the character, so the fill does not
 * depend on the font having a solid block and stays solid at 8x16. */
#define PATTERN_CELL_LIT  ((uint16_t)(' ' | ((uint16_t)C_WHITE << 12)))
#define PATTERN_CELL_DARK ((uint16_t)(' ' | ((uint16_t)C_BLACK << 12)))

static uint8_t cell_attribute(void) {
    return (uint8_t)((background << 4) | (foreground & 0x0F));
}

static uint16_t cell(char c) {
    return (uint16_t)((uint16_t)(uint8_t)c | ((uint16_t)cell_attribute() << 8));
}

/* ---- Serial ---- */

void serial_putc(char c) {
    int spin = SERIAL_SPIN_LIMIT;

    while (spin-- > 0) {
        if (inb(SERIAL_PORT + 5) & SERIAL_DATA_READY) {
            outb(SERIAL_PORT, (uint8_t)c);
            return;
        }
    }
}

void serial_write(const char* text) {
    for (int i = 0; text[i]; i++)
        serial_putc(text[i]);
}

void serial_init(void) {
    outb(SERIAL_PORT + 1, 0x00);   /* no interrupts */
    outb(SERIAL_PORT + 3, 0x80);   /* enable the divisor latch */
    outb(SERIAL_PORT + 0, 0x03);   /* 38400 baud */
    outb(SERIAL_PORT + 1, 0x00);
    outb(SERIAL_PORT + 3, 0x03);   /* 8 data bits, no parity, 1 stop bit */
    outb(SERIAL_PORT + 2, 0xC7);   /* enable + clear the FIFOs */
    outb(SERIAL_PORT + 4, 0x0B);   /* IRQs on, RTS and DSR asserted */
}

void console_set_serial(int enabled) {
    mirror_serial = enabled ? 1 : 0;
}

int console_get_serial(void) {
    return mirror_serial;
}

/* ---- Cursor ---- */

static void move_hardware_cursor(void) {
    uint16_t offset = (uint16_t)(cursor_row * CONSOLE_COLS + cursor_column);

    outb(VGA_CURSOR_INDEX, 0x0F);
    outb(VGA_CURSOR_DATA, (uint8_t)(offset & 0xFF));
    outb(VGA_CURSOR_INDEX, 0x0E);
    outb(VGA_CURSOR_DATA, (uint8_t)((offset >> 8) & 0xFF));
}

void console_get_cursor(int* column, int* row) {
    if (column) *column = cursor_column;
    if (row) *row = cursor_row;
}

void console_set_cursor(int column, int row) {
    if (column < 0) column = 0;
    if (column >= CONSOLE_COLS) column = CONSOLE_COLS - 1;
    if (row < 0) row = 0;
    if (row >= CONSOLE_ROWS) row = CONSOLE_ROWS - 1;

    cursor_column = column;
    cursor_row = row;
    move_hardware_cursor();
}

/* ---- Screen ---- */

/* Scrolls the screen up by one row.
 *
 * Row 0 is the top of the screen, so scrolling up means every row takes the
 * content of the row below it, new_row[r] = old_row[r+1], and the last row is
 * blanked.
 *
 * Copying the other way, new_row[r] = old_row[r-1], scrolls the screen down. The
 * version that did that had the wrong loop direction as well: ascending with a
 * source one row above the destination overwrites each source before it is read,
 * so every row ends up holding whatever was on the top row and the first line of
 * the boot log gets replicated down the whole screen.
 *
 * Ascending is safe here because the source is the row below the destination:
 * buffer[r] is written before buffer[r+1] is used as a source, so no source is
 * ever clobbered before it is read. */
void console_scroll(void) {
    for (int row = 0; row < CONSOLE_ROWS - 1; row++) {
        for (int col = 0; col < CONSOLE_COLS; col++)
            VGA_BUFFER[row * CONSOLE_COLS + col] =
                VGA_BUFFER[(row + 1) * CONSOLE_COLS + col];
    }

    uint16_t blank = cell(' ');

    for (int col = 0; col < CONSOLE_COLS; col++)
        VGA_BUFFER[(CONSOLE_ROWS - 1) * CONSOLE_COLS + col] = blank;
}
/* Blanks the row the cursor is on and puts it back at column 0. The line editor
 * calls this before drawing a prompt, so it must touch the current row only. */
void console_clear_line(void) {
    uint16_t blank = cell(' ');

    for (int col = 0; col < CONSOLE_COLS; col++)
        VGA_BUFFER[cursor_row * CONSOLE_COLS + col] = blank;

    cursor_column = 0;
    move_hardware_cursor();
}

void console_clear(void) {
    uint16_t blank = cell(' ');

    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLS; i++)
        VGA_BUFFER[i] = blank;

    cursor_column = 0;
    cursor_row = 0;
    move_hardware_cursor();

    /* A clear wipes the fill, so forget it too: leaving the pattern recorded
     * while the screen is blank would make `dither invert` claim to flip
     * something that is not there. */
    pattern = PATTERN_NONE;

    if (mirror_serial)
        serial_write("\r\n");
}

/* ---- Full screen pattern ---- */

int console_pattern(void) {
    return pattern;
}

void console_fill_pattern(int which) {
    if (which != PATTERN_EVEN && which != PATTERN_ODD) {
        console_pattern_off();
        return;
    }

    console_put_cell_pattern(0, 0, CONSOLE_COLS, CONSOLE_ROWS, which, 0, 0);
    pattern = which;

    /* Top left, so the prompt prints over the fill instead of at whatever row
     * the last command happened to leave the cursor on. */
    cursor_column = 0;
    cursor_row = 0;
    move_hardware_cursor();
}

/* The same pattern over a rectangle, with an offset.
 *
 * This is the piece an animation needs. console_fill_pattern() always starts at
 * the top left and covers everything, which is right for `dither on` and useless
 * for moving something around: there are no addressable cells and no offset, so a
 * shape cannot be placed or slid.
 *
 * (start_x, start_y) is the top left of the rectangle, width and height are its
 * size in cells. offset_x and offset_y shift the pattern without touching the
 * cursor, so a shape can slide while the shell's own text stays put.
 *
 * The pattern stays anchored to the screen rather than restarting inside the
 * rectangle, which is what makes a shape line up with the full screen fill it
 * sits on instead of showing stripes inside itself.
 *
 * Coordinates outside the screen are skipped, not clipped, so a shape can hang off
 * any edge without writing outside the buffer or disturbing the cursor. `which` is
 * PATTERN_EVEN or PATTERN_ODD; anything else draws nothing. */
void console_put_cell_pattern(int start_x, int start_y, int width, int height,
                              int which, int offset_x, int offset_y) {
    if (which != PATTERN_EVEN && which != PATTERN_ODD)
        return;

    for (int row = 0; row < height; row++) {
        int y = start_y + row;

        if (y < 0 || y >= CONSOLE_ROWS)
            continue;

        for (int col = 0; col < width; col++) {
            int x = start_x + col;

            if (x < 0 || x >= CONSOLE_COLS)
                continue;

            /* Offset on both axes before the parity test. Including the row
             * is what turns a left/right stripe into a checkerboard, and
             * it keeps a shape lined up with the fill underneath it instead of
             * restarting the stripes inside itself. */
            int parity = ((x + offset_x) + ((y + offset_y) * CONSOLE_COLS)) & 1;
            int lit = (parity == (which == PATTERN_ODD));

            VGA_BUFFER[y * CONSOLE_COLS + x] = lit ? PATTERN_CELL_LIT
                                                  : PATTERN_CELL_DARK;
        }
    }
}

void console_pattern_off(void) {
    pattern = PATTERN_NONE;
    console_clear();
}

void console_init(void) {
    serial_init();
    console_set_color(C_LIGHTGRAY, C_BLACK);
    console_clear();
}

void console_backspace(void) {
    if (cursor_column > 0) {
        cursor_column--;
    } else if (cursor_row > 0) {
        cursor_row--;
        cursor_column = CONSOLE_COLS - 1;
    } else {
        return;
    }

    VGA_BUFFER[cursor_row * CONSOLE_COLS + cursor_column] = cell(' ');
    move_hardware_cursor();

    if (mirror_serial) {
        serial_putc('\b');
        serial_putc(' ');
        serial_putc('\b');
    }
}

void console_putc(char c) {
    if (mirror_serial)
        serial_putc(c);

    /* The control characters each do their own thing and then return. Letting
     * them fall through to the write below also paints the control character
     * into a cell, and the line editor's redraw then smears that cell across
     * the row. */
    if (c == '\n') {
        cursor_column = 0;
        cursor_row++;

        while (cursor_row >= CONSOLE_ROWS) {
            console_scroll();
            cursor_row--;
        }

        move_hardware_cursor();
        return;
    }

    if (c == '\r') {
        cursor_column = 0;
        move_hardware_cursor();
        return;
    }

    if (c == '\b') {
        console_backspace();
        return;
    }

    if ((uint8_t)c < 0x20) {
        /* char is signed on i386, so this test has to be unsigned or it would
         * swallow every CP437 glyph from 0x80 up as well. */
        return;
    }

    if (c == '\t')
        cursor_column = (cursor_column + 8) & ~7;

    if (cursor_column >= CONSOLE_COLS) {
        cursor_column = 0;
        cursor_row++;
    }

    while (cursor_row >= CONSOLE_ROWS) {
        console_scroll();
        cursor_row--;
    }

    VGA_BUFFER[cursor_row * CONSOLE_COLS + cursor_column] = cell(c);
    cursor_column++;
    move_hardware_cursor();
}
void console_write_n(const char* text, int length) {
    for (int i = 0; i < length && text[i]; i++)
        console_putc(text[i]);
}

void console_write(const char* text) {
    if (!text)
        return;

    for (int i = 0; text[i]; i++)
        console_putc(text[i]);
}

void console_repeat(char c, int count) {
    for (int i = 0; i < count; i++)
        console_putc(c);
}

void console_set_color(uint8_t fg, uint8_t bg) {
    foreground = fg & 0x0F;
    background = bg & 0x0F;
}

void console_get_color(uint8_t* fg, uint8_t* bg) {
    if (fg) *fg = foreground;
    if (bg) *bg = background;
}

/* ---- Formatted output ---- */
/* %c %s %d %i %u %x %X %p %% with an optional 0 flag, an optional - flag and a
 * decimal width. Length modifiers are accepted and ignored: this is a 32-bit
 * target, so %lu reads a 32-bit long just like %u. */

static void put_unsigned(uint32_t value, uint32_t radix, int upper,
                         int width, int zero_pad, int left_align) {
    static const char lower_digits[] = "0123456789abcdef";
    static const char upper_digits[] = "0123456789ABCDEF";
    const char* digits = upper ? upper_digits : lower_digits;
    char buffer[34];
    int length = 0;

    if (value == 0)
        buffer[length++] = '0';

    while (value != 0) {
        buffer[length++] = digits[value % radix];
        value /= radix;
    }

    int padding = width - length;
    if (!left_align) {
        for (int n = padding; n > 0; n--)
            console_putc(zero_pad ? '0' : ' ');
    }

    while (length > 0)
        console_putc(buffer[--length]);

    if (left_align) {
        for (int n = padding; n > 0; n--)
            console_putc(' ');
    }
}

static void put_string(const char* text, int width, int zero_pad, int left_align) {
    int length = 0;

    if (!text)
        text = "(null)";

    while (text[length])
        length++;

    int padding = width - length;
    if (!left_align) {
        for (int n = padding; n > 0; n--)
            console_putc(zero_pad ? '0' : ' ');
    }

    console_write_n(text, length);

    if (left_align) {
        for (int n = padding; n > 0; n--)
            console_putc(' ');
    }
}

static void vconsole_printf(const char* fmt, __builtin_va_list args) {
    for (int i = 0; fmt[i]; i++) {
        if (fmt[i] != '%') {
            console_putc(fmt[i]);
            continue;
        }

        i++;
        if (!fmt[i])
            break;

        int zero_pad = 0;
        int left_align = 0;
        int width = 0;

        while (fmt[i] == '0' || fmt[i] == '-') {
            if (fmt[i] == '-')
                left_align = 1;
            else
                zero_pad = 1;
            i++;
        }

        while (fmt[i] >= '0' && fmt[i] <= '9') {
            width = width * 10 + (fmt[i] - '0');
            i++;
        }

        /* Accept and ignore l/h/z/j/t/L: everything here is 32 bits wide. */
        while (fmt[i] == 'l' || fmt[i] == 'h' || fmt[i] == 'z' ||
               fmt[i] == 'j' || fmt[i] == 't' || fmt[i] == 'L')
            i++;

        char spec = fmt[i];
        if (!spec)
            break;

        switch (spec) {
            case 'c':
                console_putc((char)__builtin_va_arg(args, int));
                break;

            case 's':
                put_string(__builtin_va_arg(args, const char*), width,
                           zero_pad, left_align);
                break;

            case 'd':
            case 'i': {
                int value = __builtin_va_arg(args, int);
                uint32_t magnitude;
                int negative = value < 0;

                if (negative)
                    magnitude = (uint32_t)0 - (uint32_t)value;
                else
                    magnitude = (uint32_t)value;

                if (negative && !zero_pad)
                    console_putc('-');

                put_unsigned(magnitude, 10, 0, width, zero_pad, left_align);
                break;
            }

            case 'u':
                put_unsigned(__builtin_va_arg(args, unsigned int), 10, 0,
                             width, zero_pad, left_align);
                break;

            case 'x':
                put_unsigned(__builtin_va_arg(args, unsigned int), 16, 0,
                             width, zero_pad, left_align);
                break;

            case 'X':
                put_unsigned(__builtin_va_arg(args, unsigned int), 16, 1,
                             width, zero_pad, left_align);
                break;

            case 'p':
                put_unsigned((uint32_t)(uintptr_t)__builtin_va_arg(args, void*),
                             16, 0, 8, 1, left_align);
                break;

            case '%':
                console_putc('%');
                break;

            default:
                console_putc('%');
                console_putc(spec);
                break;
        }
    }
}

void console_printf(const char* fmt, ...) {
    __builtin_va_list args;

    __builtin_va_start(args, fmt);
    vconsole_printf(fmt, args);
    __builtin_va_end(args);
}