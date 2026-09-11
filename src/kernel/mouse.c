/* Cubic System Software - PS/2 Mouse Driver */

#include "mouse.h"
#include "framebuffer.h"

static int mouse_x_pos = 400;
static int mouse_y_pos = 300;
static uint8_t mouse_buttons = 0;

static uint8_t mouse_cycle = 0;
static int8_t mouse_byte[3];

static void outb(uint16_t port, uint8_t val) {
    __asm__ __volatile__("outb %0, %1" : : "a"(val), "Nd"(port));
}

static uint8_t inb(uint16_t port) {
    uint8_t ret;
    __asm__ __volatile__("inb %1, %0" : "=a"(ret) : "Nd"(port));
    return ret;
}

static void wait_input(void) {
    uint32_t timeout = 100000;
    while (timeout--) {
        if (inb(0x64) & 1) return;
    }
}

static void wait_output(void) {
    uint32_t timeout = 100000;
    while (timeout--) {
        if (!(inb(0x64) & 2)) return;
    }
}

static void mouse_write(uint8_t val) {
    wait_output();
    outb(0x64, 0xD4);
    wait_output();
    outb(0x60, val);
}

static uint8_t mouse_read(void) {
    wait_input();
    return inb(0x60);
}

static void dbg(char c) {
    while (!(inb(0x3F8 + 5) & 0x20));
    outb(0x3F8, c);
}

void mouse_init(void) {
    uint32_t i;
    uint8_t status;

    dbg('m'); dbg('1');

    /* Flush any pending data from PS/2 controller */
    while (inb(0x64) & 1) {
        inb(0x60);
    }

    dbg('m'); dbg('2');

    /* Disable devices temporarily */
    wait_output(); outb(0x64, 0xAD);
    wait_output(); outb(0x64, 0xA7);

    /* Flush again */
    while (inb(0x64) & 1) {
        inb(0x60);
    }

    dbg('m'); dbg('3');

    /* Set controller config: enable IRQ12, disable IRQ1 */
    wait_output(); outb(0x64, 0x20);
    wait_input(); status = inb(0x60);
    status |= 0x02;   /* enable IRQ12 (bit 1) */
    status &= ~0x10;  /* disable IRQ1 (bit 4) for now */
    wait_output(); outb(0x64, 0x60);
    wait_output(); outb(0x60, status);

    dbg('m'); dbg('4');

    /* Enable auxiliary device (mouse) */
    wait_output(); outb(0x64, 0xA8);

    /* Also enable IRQ1 for keyboard */
    wait_output(); outb(0x64, 0x20);
    wait_input(); status = inb(0x60);
    status |= 0x03;   /* enable both IRQ1 and IRQ12 */
    wait_output(); outb(0x64, 0x60);
    wait_output(); outb(0x60, status);

    dbg('m'); dbg('5');

    /* Reset mouse */
    mouse_write(0xFF);
    mouse_read();  /* discard response */

    dbg('m'); dbg('6');

    /* Default settings */
    mouse_write(0xF6);
    mouse_read();

    dbg('m'); dbg('7');

    /* Enable data reporting */
    mouse_write(0xF4);
    mouse_read();

    dbg('m'); dbg('8');

    /* Set initial position */
    mouse_x_pos = 8;
    mouse_y_pos = 8;

    /* Clear any garbage bytes */
    for (i = 0; i < 100000; i++) {
        if (inb(0x64) & 1) inb(0x60);
    }

    dbg('m'); dbg('9');
}

void mouse_handler(void) {
    uint8_t byte = inb(0x60);

    /* Debug: write 'M' to serial when handler fires */
    while (!(inb(0x3F8 + 5) & 0x20));
    outb(0x3F8, 'M');

    switch (mouse_cycle) {
        case 0:
            mouse_byte[0] = byte;
            if (byte & 0x08) mouse_cycle = 1;
            break;
        case 1:
            mouse_byte[1] = byte;
            mouse_cycle = 2;
            break;
        case 2:
            mouse_byte[2] = byte;
            mouse_cycle = 0;

            mouse_buttons = mouse_byte[0] & 0x07;

            int dx = mouse_byte[1];
            int dy = -mouse_byte[2];

            mouse_x_pos += dx;
            mouse_y_pos += dy;

            if (mouse_x_pos < 0) mouse_x_pos = 0;
            if (mouse_y_pos < 0) mouse_y_pos = 0;
            if (mouse_x_pos >= (int)screen_width) mouse_x_pos = screen_width - 1;
            if (mouse_y_pos >= (int)screen_height) mouse_y_pos = screen_height - 1;
            break;
    }
}

int mouse_x(void) { return mouse_x_pos; }
int mouse_y(void) { return mouse_y_pos; }
int mouse_button(int button) { return (mouse_buttons >> button) & 1; }
