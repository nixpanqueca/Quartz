/* Cubic System Software - PS/2 Mouse Driver */

#include "mouse.h"
#include "framebuffer.h"

static volatile int mouse_x_pos;
static volatile int mouse_y_pos;
static volatile uint8_t mouse_buttons;

static uint8_t mouse_cycle;
static int8_t mouse_byte[3];

static void pOutb(uint16_t port, uint8_t val) {
    __asm__ __volatile__("outb %0, %1" : : "a"(val), "Nd"(port));
}

static uint8_t pInb(uint16_t port) {
    uint8_t ret;
    __asm__ __volatile__("inb %1, %0" : "=a"(ret) : "Nd"(port));
    return ret;
}

static void ps2_wait_input(void) {
    uint32_t timeout = 100000;
    while (timeout--)
        if (pInb(0x64) & 1) return;
}

static void ps2_wait_output(void) {
    uint32_t timeout = 100000;
    while (timeout--)
        if (!(pInb(0x64) & 2)) return;
}

static void mouse_write(uint8_t val) {
    ps2_wait_output();
    pOutb(0x64, 0xD4);
    ps2_wait_output();
    pOutb(0x60, val);
}

static uint8_t mouse_read(void) {
    ps2_wait_input();
    return pInb(0x60);
}

void mouse_init(void) {
    uint8_t status;

    /* Flush output buffer */
    while (pInb(0x64) & 1)
        pInb(0x60);

    /* Disable keyboard + mouse at controller */
    ps2_wait_output(); pOutb(0x64, 0xAD);
    ps2_wait_output(); pOutb(0x64, 0xA7);

    /* Flush again */
    while (pInb(0x64) & 1)
        pInb(0x60);

    /* Read controller config byte */
    ps2_wait_output(); pOutb(0x64, 0x20);
    ps2_wait_input(); status = pInb(0x60);

    /* Enable IRQ12 (bit 1), enable keyboard (bit 0), enable both clock lines (clear bits 2,3) */
    status |= 0x03;
    status &= ~0x0C;

    /* Write config back */
    ps2_wait_output(); pOutb(0x64, 0x60);
    ps2_wait_output(); pOutb(0x60, status);

    /* Enable mouse on controller */
    ps2_wait_output(); pOutb(0x64, 0xA8);

    /* Re-enable keyboard scanning */
    ps2_wait_output(); pOutb(0x64, 0xAE);

    /* Flush any leftover data */
    while (pInb(0x64) & 1)
        pInb(0x60);

    /* Reset mouse */
    mouse_write(0xFF);
    mouse_read();

    /* Default settings */
    mouse_write(0xF6);
    mouse_read();

    /* Enable data reporting */
    mouse_write(0xF4);
    mouse_read();

    /* Start at center of screen */
    mouse_x_pos = (int)screen_width / 2;
    mouse_y_pos = (int)screen_height / 2;
}

void mouse_handler(void) {
    uint8_t byte = pInb(0x60);

    switch (mouse_cycle) {
        case 0:
            mouse_byte[0] = byte;
            if (byte & 0x08)
                mouse_cycle = 1;
            break;
        case 1:
            mouse_byte[1] = byte;
            mouse_cycle = 2;
            break;
        case 2:
            mouse_byte[2] = byte;
            mouse_cycle = 0;

            mouse_buttons = mouse_byte[0] & 0x07;

            int dx = (int)(int8_t)mouse_byte[1];
            int dy = -(int)(int8_t)mouse_byte[2];

            mouse_x_pos += dx;
            mouse_y_pos += dy;

            if (mouse_x_pos < 0) mouse_x_pos = 0;
            if (mouse_y_pos < 0) mouse_y_pos = 0;
            if (mouse_x_pos >= (int)screen_width) mouse_x_pos = (int)screen_width - 1;
            if (mouse_y_pos >= (int)screen_height) mouse_y_pos = (int)screen_height - 1;
            break;
    }
}

int mouse_x(void) { return mouse_x_pos; }
int mouse_y(void) { return mouse_y_pos; }
int mouse_button(int button) { return (mouse_buttons >> button) & 1; }
