/* Cubic System Software - Framebuffer */
/* Just the basics for now! */

#ifndef FRAMEBUFFER_H
#define FRAMEBUFFER_H

#include <stdint.h>

/* Screen resolution (set by GRUB, stored for later use) */
extern uint32_t screen_width;
extern uint32_t screen_height;

/* Initialize framebuffer from multiboot */
int framebuffer_init(uint32_t mb_magic, uint32_t mb_info_addr);

/* Clear entire screen to a color */
void fb_clear(uint8_t r, uint8_t g, uint8_t b);

#define FB_PATTERN_MACGRAY 0

void FB_drawpattern(uint32_t x1, uint32_t y1, uint32_t x2, uint32_t y2, uint32_t pattern);

void FB_drawrect(uint32_t x1, uint32_t y1, uint32_t x2, uint32_t y2, uint32_t color);

void FB_putchar(uint32_t x, uint32_t y, char c, uint32_t color, uint32_t size);
void FB_write(uint32_t x, uint32_t y, const char* str, uint32_t color, uint32_t size);

void delay(uint32_t ms);

/* Cursor */
void fb_cursor_update(void);
void fb_cursor_invalidate(void);

/* BMP drawing */
void FB_drawbmp(uint32_t x, uint32_t y, const void* bmp_data);

/* RTC */
void rtc_read(uint8_t* hour, uint8_t* min, uint8_t* sec);

#endif
